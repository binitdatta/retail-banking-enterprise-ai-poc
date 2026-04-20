"""
NexusBank ChatBot — Operator DB Service
Write operations performed by ROLE_NEXUS_ADMIN.
Every write is audit-logged. App user needs INSERT/UPDATE on nexusbank_db.
"""
from __future__ import annotations

import logging
from datetime import date, datetime
from typing import Any, Dict, Optional

from sqlalchemy import text

from services.db_service import get_engine, _one, _rows

log = logging.getLogger(__name__)


def _exec(sql: str, params: dict) -> int:
    """Execute DML, return lastrowid."""
    with get_engine().begin() as conn:
        result = conn.execute(text(sql), params)
        return result.lastrowid


def _audit(action: str, entity: str, entity_id: int,
           operator_username: str, details: str) -> None:
    try:
        _exec("""
            INSERT INTO audit_log
                (action, entity_type, entity_id, performed_by, description, created_at)
            VALUES
                (:action, :entity, :eid, :by, :details, NOW())
        """, {
            "action": action, "entity": entity, "eid": entity_id,
            "by": operator_username, "details": details,
        })
    except Exception as exc:
        log.warning("Audit log write failed: %s", exc)


# ── 1. Open a new account ─────────────────────────────────────────────────────

def get_account_products() -> list:
    return _rows("""
        SELECT product_id, product_code, product_name, product_type,
               min_balance, apy_rate, description
        FROM account_products
        WHERE is_active = 1
        ORDER BY product_type, product_name
    """)


def open_account(customer_id: int, product_code: str,
                 nickname: str | None,
                 opening_deposit: float,
                 operator_username: str) -> Dict[str, Any]:
    product = _one(
        "SELECT * FROM account_products WHERE product_code = :pc AND is_active = 1",
        {"pc": product_code},
    )
    if not product:
        return {"success": False, "error": f"Product code '{product_code}' not found."}

    if opening_deposit < float(product["min_balance"] or 0):
        return {"success": False,
                "error": f"Minimum opening deposit is ${product['min_balance']:,.2f}."}

    # Generate account number: last existing + 1
    last = _one("SELECT MAX(CAST(account_number AS UNSIGNED)) AS mx FROM accounts")
    new_num = str(int(last["mx"] or 1000000000) + 1).zfill(12)

    account_id = _exec("""
        INSERT INTO accounts
            (customer_id, product_id, account_number, nickname,
             account_status, current_balance, available_balance,
             currency_code, annual_percentage_yield,
             opened_date, created_at)
        VALUES
            (:cid, :pid, :num, :nick,
             'ACTIVE', :bal, :bal,
             'USD', :apy,
             CURDATE(), NOW())
    """, {
        "cid":  customer_id,
        "pid":  product["product_id"],
        "num":  new_num,
        "nick": nickname or product["product_name"],
        "bal":  opening_deposit,
        "apy":  product["apy_rate"] or 0,
    })

    _audit("OPEN_ACCOUNT", "accounts", account_id, operator_username,
           f"Opened {product['product_name']} (#{new_num}) "
           f"with ${opening_deposit:,.2f} for customer_id={customer_id}")

    return {
        "success":        True,
        "account_id":     account_id,
        "account_number": new_num,
        "product_name":   product["product_name"],
        "opening_deposit": opening_deposit,
    }


# ── 2. Update customer profile ────────────────────────────────────────────────

def update_customer_profile(customer_id: int,
                             fields: Dict[str, str],
                             operator_username: str) -> Dict[str, Any]:
    allowed = {"email", "phone", "address_line1", "address_line2",
               "city", "state_code", "zip_code", "country_code"}
    updates = {k: v for k, v in fields.items() if k in allowed and v is not None}
    if not updates:
        return {"success": False, "error": "No valid fields to update."}

    set_clause = ", ".join(f"{k} = :{k}" for k in updates)
    updates["cid"] = customer_id
    updates["now"] = datetime.utcnow()

    with get_engine().begin() as conn:
        conn.execute(text(
            f"UPDATE customers SET {set_clause}, updated_at = :now WHERE customer_id = :cid"
        ), updates)

    _audit("UPDATE_PROFILE", "customers", customer_id, operator_username,
           f"Updated fields: {list(updates.keys())} for customer_id={customer_id}")

    return {"success": True, "updated_fields": list(updates.keys())}


# ── 3. Post customer alert ────────────────────────────────────────────────────

VALID_ALERT_TYPES = {
    "PAYMENT_DUE", "LOW_BALANCE", "LARGE_TRANSACTION",
    "LOAN_APPROVED", "LOAN_DECLINED", "GENERAL", "SECURITY",
}


def post_customer_alert(customer_id: int,
                        alert_type: str,
                        message: str,
                        operator_username: str) -> Dict[str, Any]:
    if alert_type not in VALID_ALERT_TYPES:
        alert_type = "GENERAL"

    alert_id = _exec("""
        INSERT INTO customer_alerts
            (customer_id, alert_type, message, is_read, created_at)
        VALUES
            (:cid, :atype, :msg, 0, NOW())
    """, {"cid": customer_id, "atype": alert_type, "msg": message})

    _audit("POST_ALERT", "customer_alerts", alert_id, operator_username,
           f"Alert [{alert_type}] posted for customer_id={customer_id}: {message[:80]}")

    return {"success": True, "alert_id": alert_id, "alert_type": alert_type}


# ── 4. Change account status ──────────────────────────────────────────────────

VALID_STATUSES = {"ACTIVE", "FROZEN", "CLOSED", "DORMANT", "SUSPENDED"}


def change_account_status(account_id: int,
                           new_status: str,
                           reason: str,
                           operator_username: str) -> Dict[str, Any]:
    if new_status not in VALID_STATUSES:
        return {"success": False,
                "error": f"Invalid status '{new_status}'. "
                         f"Valid: {', '.join(VALID_STATUSES)}"}

    account = _one(
        "SELECT account_id, account_number, account_status FROM accounts WHERE account_id = :aid",
        {"aid": account_id},
    )
    if not account:
        return {"success": False, "error": f"Account {account_id} not found."}

    old_status = account["account_status"]

    with get_engine().begin() as conn:
        conn.execute(text("""
            UPDATE accounts
            SET account_status = :status, updated_at = NOW()
            WHERE account_id = :aid
        """), {"status": new_status, "aid": account_id})

    _audit("CHANGE_ACCOUNT_STATUS", "accounts", account_id, operator_username,
           f"Account #{account['account_number']} status: "
           f"{old_status} → {new_status}. Reason: {reason}")

    return {
        "success":      True,
        "account_id":   account_id,
        "account_number": account["account_number"],
        "old_status":   old_status,
        "new_status":   new_status,
    }


# ── 5. Create loan application ────────────────────────────────────────────────

def get_loan_products() -> list:
    return _rows("""
        SELECT loan_product_id, product_code, product_name, loan_type,
               min_amount, max_amount, min_term_months, max_term_months,
               description
        FROM loan_products
        WHERE is_active = 1
        ORDER BY loan_type, product_name
    """)


def create_loan_application(customer_id: int,
                             product_code: str,
                             requested_amount: float,
                             term_months: int,
                             purpose: str,
                             rate_type: str,
                             operator_username: str) -> Dict[str, Any]:
    product = _one(
        "SELECT * FROM loan_products WHERE product_code = :pc AND is_active = 1",
        {"pc": product_code},
    )
    if not product:
        return {"success": False, "error": f"Loan product '{product_code}' not found."}

    if requested_amount < float(product["min_amount"] or 0):
        return {"success": False,
                "error": f"Minimum loan amount is ${product['min_amount']:,.2f}."}
    if requested_amount > float(product["max_amount"] or 9999999):
        return {"success": False,
                "error": f"Maximum loan amount is ${product['max_amount']:,.2f}."}

    customer = _one(
        "SELECT credit_score, annual_income, employment_status FROM customers WHERE customer_id = :cid",
        {"cid": customer_id},
    )

    app_num = f"APP-{datetime.utcnow().strftime('%Y%m%d%H%M%S')}-{customer_id}"

    if rate_type not in ("FIXED", "VARIABLE"):
        rate_type = "FIXED"

    app_id = _exec("""
        INSERT INTO loan_applications
            (customer_id, loan_product_id, application_number,
             loan_type, requested_amount, requested_term_months,
             requested_rate_type, purpose, application_status,
             applicant_credit_score, applicant_annual_income,
             applicant_employment_status, submitted_at, created_at)
        VALUES
            (:cid, :pid, :num,
             :ltype, :amount, :term,
             :rtype, :purpose, 'PENDING',
             :cscore, :income,
             :emp, NOW(), NOW())
    """, {
        "cid":    customer_id,
        "pid":    product["loan_product_id"],
        "num":    app_num,
        "ltype":  product["loan_type"],
        "amount": requested_amount,
        "term":   term_months,
        "rtype":  rate_type,
        "purpose": purpose,
        "cscore": customer.get("credit_score") if customer else None,
        "income": customer.get("annual_income") if customer else None,
        "emp":    customer.get("employment_status") if customer else None,
    })

    _audit("CREATE_LOAN_APPLICATION", "loan_applications", app_id, operator_username,
           f"App {app_num}: {product['product_name']} ${requested_amount:,.2f} "
           f"/{term_months}mo for customer_id={customer_id}")

    return {
        "success":            True,
        "application_id":     app_id,
        "application_number": app_num,
        "product_name":       product["product_name"],
        "loan_type":          product["loan_type"],
        "requested_amount":   requested_amount,
        "term_months":        term_months,
        "status":             "PENDING",
    }