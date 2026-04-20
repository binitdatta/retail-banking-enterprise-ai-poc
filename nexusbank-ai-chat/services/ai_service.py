"""
NexusBank ChatBot — AI Service
Streams responses from Anthropic Claude with live banking context injected.
"""
from __future__ import annotations

import json
import logging
from typing import Dict, Generator, List

import anthropic

from config.settings import Config

log = logging.getLogger(__name__)
_client: anthropic.Anthropic | None = None


def _get_client() -> anthropic.Anthropic:
    global _client
    if _client is None:
        _client = anthropic.Anthropic(api_key=Config.ANTHROPIC_API_KEY)
    return _client


def build_system_prompt(customer: Dict, financial_ctx: Dict) -> str:
    import decimal, datetime

    def _fmt(v):
        if isinstance(v, decimal.Decimal): return float(v)
        if isinstance(v, (datetime.date, datetime.datetime)): return str(v)
        return v

    accts     = financial_ctx.get("accounts", [])
    loans     = financial_ctx.get("loans", [])
    alerts    = financial_ctx.get("alerts", [])
    next_pmts = financial_ctx.get("next_payments", [])
    txns      = financial_ctx.get("transactions", [])
    total_dep = financial_ctx.get("total_deposits", 0)
    total_debt= financial_ctx.get("total_debt", 0)

    acct_lines = "\n".join(
        f"  ACCOUNT | {a['account_number']} | {a['product_name']} | {a['product_type']} "
        f"| balance=${float(a['current_balance'] or 0):,.2f} "
        f"| available=${float(a['available_balance'] or 0):,.2f}"
        for a in accts
    ) or "  None"

    loan_lines = "\n".join(
        f"  LOAN | {l['loan_number']} | {l['loan_type']} | {l['product_name']} "
        f"| outstanding=${float(l['outstanding_balance'] or 0):,.2f} "
        f"| rate={float(l['interest_rate'] or 0)*100:.2f}% "
        f"| monthly=${float(l['monthly_payment_amount'] or 0):,.2f} "
        f"| next_due={l['next_payment_date']}"
        for l in loans
    ) or "  None"

    pmt_lines = "\n".join(
        f"  PAYMENT | {p['loan_number']} | {p['loan_type']} "
        f"| amount=${float(p['monthly_payment_amount'] or 0):,.2f} | due={p['next_payment_date']}"
        for p in next_pmts
    ) or "  None"

    alert_lines = "\n".join(
        f"  ALERT | {a['alert_type']} | {a['message']}"
        for a in alerts[:5]
    ) or "  None"

    txn_lines = "\n".join(
        f"  TXN | {str(t.get('transaction_date',''))[:10]} | {t.get('transaction_type','')} "
        f"| ${_fmt(t.get('amount',0)):,.2f} "
        f"| {(t.get('merchant_name') or t.get('description',''))[:40]} "
        f"| acct={t.get('account_label','')}"
        for t in txns[:20]
    ) or "  None"

    return f"""You are the NexusBank AI Banking Assistant.

## STRICT RESPONSE RULE — MOST IMPORTANT INSTRUCTION ##
You are a precise banking assistant. You MUST answer ONLY what the customer asked.
DO NOT show account balances unless asked for balances.
DO NOT show transactions unless asked for transactions.
DO NOT show loans unless asked about loans or payments.
DO NOT present a financial overview/summary unless explicitly requested.
Each question has ONE correct answer type — respond with ONLY that type.

QUESTION → CORRECT RESPONSE MAPPING (follow exactly):
- asks about "balance" / "account balance" / "how much" in account → show accounts only
- asks about "transaction" / "last N transactions" / "recent activity" → show transactions only
- asks about "mortgage" / "home loan" / "property" → show mortgage loan only
- asks about "payment" / "due" / "when is my next payment" → show upcoming payments only
- asks about "spending" / "spent" / "categories" / "where did my money go" → analyse transactions only
- asks about "card" / "debit card" → show card info only
- asks about "wire" / "transfer" → show wire info only
- asks about "loan application" / "application status" → show application info only
- asks about "net position" / "net worth" / "overall summary" → show totals only

CUSTOMER
========
Name: {customer['first_name']} {customer['last_name']}
Customer#: {customer['customer_number']}
Type: {customer['customer_type']}
Credit Score: {customer.get('credit_score', 'N/A')}
Branch: {customer.get('assigned_branch', 'Not assigned')}

REFERENCE DATA (use only what is relevant to the question — do not present all of this)
========================================================================================
Total Deposits: ${total_dep:,.2f} | Total Debt: ${total_debt:,.2f} | Net: ${total_dep - total_debt:,.2f}

ACCOUNTS:
{acct_lines}

LOANS:
{loan_lines}

UPCOMING PAYMENTS:
{pmt_lines}

ALERTS:
{alert_lines}

RECENT TRANSACTIONS:
{txn_lines}

RULES:
- NEVER begin a response with account balances unless asked
- NEVER show multiple sections of data for a single-topic question
- Format currency as $1,234.56, rates as 6.85%
- Use markdown tables for lists of data
- End every response with "Is there anything else I can help you with today?"
"""


def stream_chat_response(
    messages: List[Dict],
    customer: Dict,
    financial_ctx: Dict,
) -> Generator[str, None, None]:
    system_prompt = build_system_prompt(customer, financial_ctx)
    anthropic_messages = []
    for msg in messages:
        role = "user" if msg["role"] == "user" else "assistant"
        anthropic_messages.append({"role": role, "content": msg["content"]})

    try:
        client = _get_client()
        with client.messages.stream(
            model=Config.ANTHROPIC_MODEL,
            max_tokens=Config.ANTHROPIC_MAX_TOKENS,
            system=system_prompt,
            messages=anthropic_messages,
        ) as stream:
            for text_chunk in stream.text_stream:
                yield f"data: {json.dumps({'type': 'delta', 'text': text_chunk})}\n\n"
        yield f"data: {json.dumps({'type': 'done'})}\n\n"

    except anthropic.APIConnectionError as exc:
        log.error("Anthropic connection error: %s", exc)
        yield f"data: {json.dumps({'type': 'error', 'text': 'Connection error. Please try again.'})}\n\n"
    except anthropic.RateLimitError:
        yield f"data: {json.dumps({'type': 'error', 'text': 'Rate limit reached. Please wait a moment.'})}\n\n"
    except anthropic.APIStatusError as exc:
        log.error("Anthropic API error %s: %s", exc.status_code, exc.message)
        yield f"data: {json.dumps({'type': 'error', 'text': 'AI service unavailable. Please try again.'})}\n\n"
    except Exception as exc:
        log.exception("Unexpected AI error: %s", exc)
        yield f"data: {json.dumps({'type': 'error', 'text': 'An unexpected error occurred.'})}\n\n"