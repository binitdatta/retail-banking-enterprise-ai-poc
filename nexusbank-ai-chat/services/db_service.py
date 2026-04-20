"""
NexusBank ChatBot — Database Service
Direct SQLAlchemy reads against nexusbank_db.
No ORM models — raw SQL via text() for speed and control.
DBA owns DDL; app is read-only for chatbot queries.
"""
from __future__ import annotations

import logging
from typing import Any, Dict, List, Optional

from sqlalchemy import create_engine, text
from sqlalchemy.pool import QueuePool

from config.settings import Config

log = logging.getLogger(__name__)

# ── Engine (singleton) ────────────────────────────────────────────────────────
_engine = None


def get_engine():
    global _engine
    if _engine is None:
        _engine = create_engine(
            Config.db_url(),
            poolclass=QueuePool,
            pool_size=Config.DB_POOL_SIZE,
            pool_recycle=Config.DB_POOL_RECYCLE,
            pool_pre_ping=True,
            echo=False,
        )
        log.info("DB engine initialised → %s/%s", Config.DB_HOST, Config.DB_NAME)
    return _engine


def _rows(sql: str, params: dict | None = None) -> List[Dict[str, Any]]:
    """Execute a SELECT and return list of dicts."""
    with get_engine().connect() as conn:
        result = conn.execute(text(sql), params or {})
        keys = list(result.keys())
        return [dict(zip(keys, row)) for row in result.fetchall()]


def _one(sql: str, params: dict | None = None) -> Optional[Dict[str, Any]]:
    rows = _rows(sql, params)
    return rows[0] if rows else None


# ── Customer lookup ───────────────────────────────────────────────────────────

def get_customer_by_keycloak_id(kc_uid: str) -> Optional[Dict]:
    return _one(
        """
        SELECT c.customer_id, c.customer_number, c.first_name, c.last_name,
               c.email, c.phone, c.customer_type, c.kyc_status,
               c.credit_score, c.annual_income, c.employment_status,
               c.employer, c.occupation, c.created_at,
               b.branch_name  AS assigned_branch
        FROM customers c
        LEFT JOIN branches b ON b.branch_id = c.assigned_branch_id
        WHERE c.keycloak_user_id = :uid AND c.is_active = 1
        """,
        {"uid": kc_uid},
    )


def get_customer_profile(customer_id: int) -> Optional[Dict]:
    return _one(
        """
        SELECT c.*, b.branch_name, b.branch_code, b.city AS branch_city
        FROM customers c
        LEFT JOIN branches b ON b.branch_id = c.assigned_branch_id
        WHERE c.customer_id = :cid
        """,
        {"cid": customer_id},
    )


# ── Accounts ──────────────────────────────────────────────────────────────────

def get_accounts_for_customer(customer_id: int) -> List[Dict]:
    return _rows(
        """
        SELECT a.account_id, a.account_number, a.nickname,
               a.account_status, a.current_balance, a.available_balance,
               a.currency_code, a.annual_percentage_yield,
               a.overdraft_protection, a.overdraft_limit,
               a.opened_date, a.maturity_date,
               p.product_name, p.product_type, p.product_code,
               b.branch_name
        FROM accounts a
        JOIN account_products p ON p.product_id = a.product_id
        LEFT JOIN branches b    ON b.branch_id  = a.branch_id
        WHERE a.customer_id = :cid
          AND a.account_status NOT IN ('CLOSED','FROZEN')
        ORDER BY p.product_type, a.opened_date
        """,
        {"cid": customer_id},
    )


def get_account_detail(account_id: int, customer_id: int) -> Optional[Dict]:
    return _one(
        """
        SELECT a.*, p.product_name, p.product_type, p.description AS product_desc,
               b.branch_name, b.phone AS branch_phone
        FROM accounts a
        JOIN account_products p ON p.product_id = a.product_id
        LEFT JOIN branches b    ON b.branch_id  = a.branch_id
        WHERE a.account_id = :aid AND a.customer_id = :cid
        """,
        {"aid": account_id, "cid": customer_id},
    )


def get_account_balance_summary(customer_id: int) -> Dict:
    """Total deposits, total available, count by type."""
    rows = _rows(
        """
        SELECT p.product_type,
               COUNT(*)                    AS acct_count,
               SUM(a.current_balance)      AS total_balance,
               SUM(a.available_balance)    AS total_available
        FROM accounts a
        JOIN account_products p ON p.product_id = a.product_id
        WHERE a.customer_id = :cid AND a.account_status = 'ACTIVE'
        GROUP BY p.product_type
        """,
        {"cid": customer_id},
    )
    return {"by_type": rows}


# ── Transactions ──────────────────────────────────────────────────────────────

def get_recent_transactions(customer_id: int, limit: int = 20) -> List[Dict]:
    return _rows(
        """
        SELECT t.transaction_id, t.transaction_ref, t.transaction_type,
               t.transaction_status, t.channel, t.amount, t.currency_code,
               t.description, t.merchant_name, t.merchant_city,
               t.transaction_date, t.posted_at,
               t.balance_before, t.balance_after,
               a.account_number,
               COALESCE(a.nickname, p.product_name) AS account_label,
               c.category_name
        FROM transactions t
        JOIN accounts a           ON a.account_id   = t.account_id
        JOIN account_products p   ON p.product_id   = a.product_id
        LEFT JOIN transaction_categories c ON c.category_id = t.category_id
        WHERE a.customer_id = :cid
        ORDER BY t.transaction_date DESC, t.created_at DESC
        LIMIT :lim
        """,
        {"cid": customer_id, "lim": limit},
    )


def get_transactions_for_account(account_id: int, customer_id: int,
                                  limit: int = 30) -> List[Dict]:
    return _rows(
        """
        SELECT t.transaction_id, t.transaction_ref, t.transaction_type,
               t.transaction_status, t.channel, t.amount, t.currency_code,
               t.description, t.merchant_name, t.merchant_city,
               t.transaction_date, t.posted_at,
               t.balance_before, t.balance_after,
               c.category_name
        FROM transactions t
        LEFT JOIN transaction_categories c ON c.category_id = t.category_id
        WHERE t.account_id = :aid
          AND EXISTS (
              SELECT 1 FROM accounts a
              WHERE a.account_id = :aid AND a.customer_id = :cid
          )
        ORDER BY t.transaction_date DESC, t.created_at DESC
        LIMIT :lim
        """,
        {"aid": account_id, "cid": customer_id, "lim": limit},
    )


def get_spending_by_category(customer_id: int, months: int = 1) -> List[Dict]:
    return _rows(
        """
        SELECT COALESCE(c.category_name, 'Uncategorised') AS category,
               COUNT(*)          AS txn_count,
               SUM(t.amount)     AS total_spent
        FROM transactions t
        JOIN accounts a ON a.account_id = t.account_id
        LEFT JOIN transaction_categories c ON c.category_id = t.category_id
        WHERE a.customer_id = :cid
          AND t.transaction_type = 'DEBIT'
          AND t.transaction_status = 'POSTED'
          AND t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL :mo MONTH)
        GROUP BY c.category_name
        ORDER BY total_spent DESC
        """,
        {"cid": customer_id, "mo": months},
    )


# ── Loans ─────────────────────────────────────────────────────────────────────

def get_loans_for_customer(customer_id: int) -> List[Dict]:
    return _rows(
        """
        SELECT l.loan_id, l.loan_number, l.loan_type, l.loan_status,
               l.rate_type, l.original_amount, l.outstanding_balance,
               l.interest_rate, l.term_months, l.monthly_payment_amount,
               l.next_payment_date, l.last_payment_date, l.last_payment_amount,
               l.total_paid, l.total_interest_paid, l.days_past_due,
               l.origination_date, l.maturity_date, l.purpose,
               lp.product_name, lp.product_code
        FROM loans l
        JOIN loan_products lp ON lp.loan_product_id = l.loan_product_id
        WHERE l.customer_id = :cid
          AND l.loan_status NOT IN ('PAID_OFF','CHARGED_OFF','CANCELLED')
        ORDER BY l.loan_type, l.origination_date DESC
        """,
        {"cid": customer_id},
    )


def get_loan_detail(loan_id: int, customer_id: int) -> Optional[Dict]:
    return _one(
        """
        SELECT l.*, lp.product_name, lp.product_code, lp.description AS product_desc
        FROM loans l
        JOIN loan_products lp ON lp.loan_product_id = l.loan_product_id
        WHERE l.loan_id = :lid AND l.customer_id = :cid
        """,
        {"lid": loan_id, "cid": customer_id},
    )


def get_mortgage_detail(loan_id: int) -> Optional[Dict]:
    return _one(
        "SELECT * FROM mortgage_details WHERE loan_id = :lid",
        {"lid": loan_id},
    )


def get_auto_loan_detail(loan_id: int) -> Optional[Dict]:
    return _one(
        "SELECT * FROM auto_loan_details WHERE loan_id = :lid",
        {"lid": loan_id},
    )


def get_student_loan_detail(loan_id: int) -> Optional[Dict]:
    return _one(
        "SELECT * FROM student_loan_details WHERE loan_id = :lid",
        {"lid": loan_id},
    )


def get_next_payments(customer_id: int) -> List[Dict]:
    return _rows(
        """
        SELECT l.loan_number, l.loan_type, l.monthly_payment_amount,
               l.next_payment_date, l.outstanding_balance,
               lp.product_name
        FROM loans l
        JOIN loan_products lp ON lp.loan_product_id = l.loan_product_id
        WHERE l.customer_id = :cid
          AND l.loan_status = 'CURRENT'
          AND l.next_payment_date IS NOT NULL
        ORDER BY l.next_payment_date
        """,
        {"cid": customer_id},
    )


def get_upcoming_payment_schedule(loan_id: int, limit: int = 6) -> List[Dict]:
    return _rows(
        """
        SELECT payment_number, due_date, scheduled_payment,
               principal_amount, interest_amount, escrow_amount,
               remaining_balance, payment_status
        FROM loan_payment_schedule
        WHERE loan_id = :lid
          AND payment_status = 'SCHEDULED'
        ORDER BY due_date
        LIMIT :lim
        """,
        {"lid": loan_id, "lim": limit},
    )


# ── Loan Applications ─────────────────────────────────────────────────────────

def get_loan_applications(customer_id: int) -> List[Dict]:
    return _rows(
        """
        SELECT la.application_id, la.application_number, la.loan_type,
               la.requested_amount, la.requested_term_months,
               la.requested_rate_type, la.purpose, la.application_status,
               la.submitted_at, la.reviewed_at, la.reviewed_by,
               la.reviewer_notes,
               lp.product_name
        FROM loan_applications la
        LEFT JOIN loan_products lp ON lp.loan_product_id = la.loan_product_id
        WHERE la.customer_id = :cid
        ORDER BY la.submitted_at DESC
        """,
        {"cid": customer_id},
    )


def get_application_detail(app_id: int, customer_id: int) -> Optional[Dict]:
    return _one(
        """
        SELECT la.*, lp.product_name,
               mad.property_address, mad.property_city, mad.property_state_code,
               mad.property_zip, mad.property_type, mad.purchase_price,
               mad.down_payment, mad.ltv_ratio, mad.is_primary_residence,
               mad.co_borrower_name, mad.annual_property_tax, mad.annual_insurance
        FROM loan_applications la
        LEFT JOIN loan_products lp          ON lp.loan_product_id = la.loan_product_id
        LEFT JOIN mortgage_application_details mad ON mad.application_id = la.application_id
        WHERE la.application_id = :aid AND la.customer_id = :cid
        """,
        {"aid": app_id, "cid": customer_id},
    )


# ── Cards ─────────────────────────────────────────────────────────────────────

def get_cards_for_customer(customer_id: int) -> List[Dict]:
    return _rows(
        """
        SELECT c.card_id, c.card_number_masked, c.card_type, c.card_network,
               c.card_status, c.cardholder_name, c.expiry_month, c.expiry_year,
               c.daily_limit, c.monthly_limit,
               c.contactless_enabled, c.online_enabled,
               c.issued_at, c.activated_at,
               a.account_number,
               COALESCE(a.nickname, p.product_name) AS account_label
        FROM cards c
        JOIN accounts a         ON a.account_id = c.account_id
        JOIN account_products p ON p.product_id = a.product_id
        WHERE c.customer_id = :cid
        ORDER BY c.issued_at DESC
        """,
        {"cid": customer_id},
    )


# ── Alerts ────────────────────────────────────────────────────────────────────

def get_unread_alerts(customer_id: int) -> List[Dict]:
    return _rows(
        """
        SELECT alert_id, alert_type, message, is_read, created_at
        FROM customer_alerts
        WHERE customer_id = :cid AND is_read = 0
        ORDER BY created_at DESC
        """,
        {"cid": customer_id},
    )


def get_all_alerts(customer_id: int, limit: int = 20) -> List[Dict]:
    return _rows(
        """
        SELECT alert_id, alert_type, message, is_read, created_at
        FROM customer_alerts
        WHERE customer_id = :cid
        ORDER BY created_at DESC
        LIMIT :lim
        """,
        {"cid": customer_id, "lim": limit},
    )


# ── Wire Transfers ────────────────────────────────────────────────────────────

def get_wire_transfers(customer_id: int) -> List[Dict]:
    return _rows(
        """
        SELECT w.wire_id, w.wire_reference, w.transfer_type, w.transfer_status,
               w.amount, w.fee_amount, w.currency_code,
               w.beneficiary_name, w.beneficiary_bank,
               w.memo, w.scheduled_date, w.executed_at,
               a.account_number,
               COALESCE(a.nickname, p.product_name) AS source_account_label
        FROM wire_transfers w
        JOIN accounts a         ON a.account_id = w.source_account_id
        JOIN account_products p ON p.product_id = a.product_id
        WHERE a.customer_id = :cid
        ORDER BY w.scheduled_date DESC
        """,
        {"cid": customer_id},
    )


# ── Beneficiaries ─────────────────────────────────────────────────────────────

def get_beneficiaries(customer_id: int) -> List[Dict]:
    return _rows(
        """
        SELECT ab.beneficiary_id, ab.beneficiary_name, ab.relationship,
               ab.allocation_percent, ab.is_primary,
               a.account_number,
               COALESCE(a.nickname, p.product_name) AS account_label
        FROM account_beneficiaries ab
        JOIN accounts a         ON a.account_id = ab.account_id
        JOIN account_products p ON p.product_id = a.product_id
        WHERE a.customer_id = :cid
        ORDER BY ab.is_primary DESC, ab.beneficiary_name
        """,
        {"cid": customer_id},
    )


# ── Financial summary for AI context ─────────────────────────────────────────

def build_financial_context(customer_id: int) -> Dict[str, Any]:
    """Aggregate snapshot passed to Claude as system context."""
    accounts     = get_accounts_for_customer(customer_id)
    loans        = get_loans_for_customer(customer_id)
    alerts       = get_unread_alerts(customer_id)
    cards        = get_cards_for_customer(customer_id)
    next_pmts    = get_next_payments(customer_id)
    transactions = get_recent_transactions(customer_id, limit=20)

    total_deposits = sum(
        float(a["current_balance"] or 0)
        for a in accounts
        if a["product_type"] in ("CHECKING", "SAVINGS", "MONEY_MARKET", "CD", "IRA")
    )
    total_debt = sum(float(l["outstanding_balance"] or 0) for l in loans)

    return {
        "accounts":         accounts,
        "loans":            loans,
        "alerts":           alerts,
        "cards":            cards,
        "next_payments":    next_pmts,
        "transactions":     transactions,
        "total_deposits":   total_deposits,
        "total_debt":       total_debt,
        "net_worth_proxy":  total_deposits - total_debt,
    }