"""
NexusBank ChatBot — Manager DB Service
Cross-customer read queries for banker/manager reports.
All queries are READ-ONLY — no writes here.
"""
from __future__ import annotations
from typing import Any, Dict, List
from services.db_service import _rows, _one


# ── Portfolio Summary ─────────────────────────────────────────────────────────

def get_portfolio_summary() -> Dict[str, Any]:
    """Total deposits, loans, customer counts by type."""
    customers = _rows("""
        SELECT customer_type,
               COUNT(*)                     AS customer_count,
               AVG(credit_score)            AS avg_credit_score,
               SUM(annual_income)           AS total_annual_income
        FROM customers
        WHERE is_active = 1
        GROUP BY customer_type
        ORDER BY customer_count DESC
    """)

    deposits = _rows("""
        SELECT p.product_type,
               COUNT(a.account_id)          AS account_count,
               SUM(a.current_balance)       AS total_balance,
               AVG(a.current_balance)       AS avg_balance
        FROM accounts a
        JOIN account_products p ON p.product_id = a.product_id
        WHERE a.account_status = 'ACTIVE'
        GROUP BY p.product_type
        ORDER BY total_balance DESC
    """)

    loans = _rows("""
        SELECT loan_type,
               COUNT(*)                     AS loan_count,
               SUM(original_amount)         AS total_originated,
               SUM(outstanding_balance)     AS total_outstanding,
               AVG(interest_rate)           AS avg_rate,
               SUM(monthly_payment_amount)  AS total_monthly_payments
        FROM loans
        WHERE loan_status NOT IN ('PAID_OFF','CHARGED_OFF','CANCELLED')
        GROUP BY loan_type
        ORDER BY total_outstanding DESC
    """)

    totals = _one("""
        SELECT
            (SELECT COUNT(*) FROM customers WHERE is_active=1)          AS total_customers,
            (SELECT SUM(current_balance) FROM accounts
              WHERE account_status='ACTIVE')                             AS total_deposits,
            (SELECT SUM(outstanding_balance) FROM loans
              WHERE loan_status NOT IN ('PAID_OFF','CHARGED_OFF','CANCELLED')) AS total_loan_book
    """)

    return {
        "customers_by_type": customers,
        "deposits_by_type":  deposits,
        "loans_by_type":     loans,
        "totals":            totals,
    }


# ── Delinquency / At-Risk ─────────────────────────────────────────────────────

def get_delinquency_report() -> List[Dict]:
    return _rows("""
        SELECT c.customer_number, c.first_name, c.last_name,
               c.email, c.credit_score, c.customer_type,
               l.loan_number, l.loan_type, l.outstanding_balance,
               l.interest_rate, l.monthly_payment_amount,
               l.days_past_due, l.late_fee_balance,
               l.next_payment_date, l.loan_status,
               lp.product_name
        FROM loans l
        JOIN customers c     ON c.customer_id     = l.customer_id
        JOIN loan_products lp ON lp.loan_product_id = l.loan_product_id
        WHERE l.loan_status NOT IN ('PAID_OFF','CHARGED_OFF','CANCELLED')
          AND (l.days_past_due > 0 OR l.late_fee_balance > 0
               OR c.credit_score < 660 OR l.next_payment_date <= CURDATE())
        ORDER BY l.days_past_due DESC, c.credit_score ASC
    """)


def get_low_balance_alerts() -> List[Dict]:
    return _rows("""
        SELECT c.customer_number, c.first_name, c.last_name,
               a.account_number, p.product_name, p.product_type,
               a.current_balance, a.available_balance
        FROM accounts a
        JOIN customers c        ON c.customer_id = a.customer_id
        JOIN account_products p ON p.product_id  = a.product_id
        WHERE a.account_status = 'ACTIVE'
          AND a.current_balance < 500
          AND p.product_type IN ('CHECKING','SAVINGS')
        ORDER BY a.current_balance ASC
    """)


# ── Loan Pipeline ─────────────────────────────────────────────────────────────

def get_loan_pipeline() -> List[Dict]:
    return _rows("""
        SELECT la.application_number, la.loan_type,
               la.requested_amount, la.requested_term_months,
               la.application_status, la.submitted_at,
               la.reviewed_at, la.reviewed_by, la.reviewer_notes,
               la.applicant_annual_income, la.applicant_credit_score,
               la.applicant_employment_status,
               c.customer_number, c.first_name, c.last_name,
               c.email, c.customer_type,
               lp.product_name
        FROM loan_applications la
        JOIN customers c          ON c.customer_id       = la.customer_id
        LEFT JOIN loan_products lp ON lp.loan_product_id = la.loan_product_id
        ORDER BY la.submitted_at DESC
    """)


def get_pipeline_by_status() -> List[Dict]:
    return _rows("""
        SELECT application_status,
               COUNT(*)               AS count,
               SUM(requested_amount)  AS total_requested,
               AVG(requested_amount)  AS avg_requested
        FROM loan_applications
        GROUP BY application_status
        ORDER BY count DESC
    """)


# ── Branch Performance ────────────────────────────────────────────────────────

def get_branch_performance() -> List[Dict]:
    return _rows("""
        SELECT b.branch_code, b.branch_name, b.city, b.state_code,
               b.manager_name,
               COUNT(DISTINCT a.customer_id)        AS customer_count,
               COUNT(DISTINCT a.account_id)         AS account_count,
               SUM(a.current_balance)               AS total_deposits,
               (SELECT COUNT(*) FROM loans l
                 WHERE l.branch_id = b.branch_id
                   AND l.loan_status NOT IN ('PAID_OFF','CHARGED_OFF','CANCELLED'))
                                                     AS active_loans,
               (SELECT SUM(l2.outstanding_balance) FROM loans l2
                 WHERE l2.branch_id = b.branch_id
                   AND l2.loan_status NOT IN ('PAID_OFF','CHARGED_OFF','CANCELLED'))
                                                     AS loan_book
        FROM branches b
        LEFT JOIN accounts a ON a.branch_id = b.branch_id
                             AND a.account_status = 'ACTIVE'
        WHERE b.is_active = 1
        GROUP BY b.branch_id, b.branch_code, b.branch_name,
                 b.city, b.state_code, b.manager_name
        ORDER BY total_deposits DESC
    """)


# ── Spending Analytics ────────────────────────────────────────────────────────

def get_spending_analytics() -> Dict[str, Any]:
    by_category = _rows("""
        SELECT COALESCE(tc.category_name, 'Uncategorised') AS category,
               COUNT(*)           AS txn_count,
               SUM(t.amount)      AS total_amount,
               AVG(t.amount)      AS avg_amount
        FROM transactions t
        JOIN accounts a ON a.account_id = t.account_id
        LEFT JOIN transaction_categories tc ON tc.category_id = t.category_id
        WHERE t.transaction_type = 'DEBIT'
          AND t.transaction_status = 'POSTED'
          AND t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        GROUP BY tc.category_name
        ORDER BY total_amount DESC
    """)

    by_channel = _rows("""
        SELECT channel,
               COUNT(*)       AS txn_count,
               SUM(amount)    AS total_amount
        FROM transactions
        WHERE transaction_type = 'DEBIT'
          AND transaction_status = 'POSTED'
          AND transaction_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        GROUP BY channel
        ORDER BY total_amount DESC
    """)

    top_merchants = _rows("""
        SELECT merchant_name,
               COUNT(*)       AS visit_count,
               SUM(amount)    AS total_spent
        FROM transactions
        WHERE transaction_type = 'DEBIT'
          AND transaction_status = 'POSTED'
          AND merchant_name IS NOT NULL
          AND transaction_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        GROUP BY merchant_name
        ORDER BY total_spent DESC
        LIMIT 10
    """)

    return {
        "by_category":    by_category,
        "by_channel":     by_channel,
        "top_merchants":  top_merchants,
    }


# ── All customers list (for operator lookups) ─────────────────────────────────

def get_all_customers() -> List[Dict]:
    return _rows("""
        SELECT customer_id, customer_number, first_name, last_name,
               email, phone, customer_type, kyc_status,
               credit_score, annual_income, employment_status,
               employer, is_active, created_at
        FROM customers
        WHERE is_active = 1
        ORDER BY last_name, first_name
    """)


def get_customer_by_number(customer_number: str) -> Dict:
    return _one("""
        SELECT c.*, b.branch_name
        FROM customers c
        LEFT JOIN branches b ON b.branch_id = c.assigned_branch_id
        WHERE c.customer_number = :cn
    """, {"cn": customer_number})


def get_all_accounts_for_customer(customer_id: int) -> List[Dict]:
    return _rows("""
        SELECT a.account_id, a.account_number, a.account_status,
               a.current_balance, a.opened_date,
               p.product_name, p.product_type, p.product_code
        FROM accounts a
        JOIN account_products p ON p.product_id = a.product_id
        WHERE a.customer_id = :cid
        ORDER BY a.opened_date DESC
    """, {"cid": customer_id})