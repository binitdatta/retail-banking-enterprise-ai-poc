"""
NexusBank ChatBot — Manager AI Service
System prompt and SSE streaming for ROLE_NEXUS_BANKER persona.
Manager sees cross-customer data and formatted reports.
"""
from __future__ import annotations

import json
import logging
from typing import Dict, Generator, List

import anthropic

from config.settings import Config

log = logging.getLogger(__name__)
_client = None


def _get_client() -> anthropic.Anthropic:
    global _client
    if _client is None:
        _client = anthropic.Anthropic(api_key=Config.ANTHROPIC_API_KEY)
    return _client


def build_manager_system_prompt(banker_username: str, portfolio: Dict) -> str:
    totals = portfolio.get("totals") or {}
    cust_types = portfolio.get("customers_by_type") or []
    loan_types = portfolio.get("loans_by_type") or []
    dep_types  = portfolio.get("deposits_by_type") or []

    cust_lines = "\n".join(
        f"  • {r['customer_type']}: {r['customer_count']} customers, "
        f"avg credit score {float(r['avg_credit_score'] or 0):.0f}"
        for r in cust_types
    ) or "  No data"

    loan_lines = "\n".join(
        f"  • {r['loan_type']}: {r['loan_count']} loans, "
        f"${float(r['total_outstanding'] or 0):,.0f} outstanding, "
        f"avg rate {float(r['avg_rate'] or 0)*100:.2f}%"
        for r in loan_types
    ) or "  No data"

    dep_lines = "\n".join(
        f"  • {r['product_type']}: {r['account_count']} accounts, "
        f"${float(r['total_balance'] or 0):,.0f} total"
        for r in dep_types
    ) or "  No data"

    return f"""You are the NexusBank Branch Manager AI Assistant — a senior banking analytics tool
accessible only to authorised bank staff (Bankers and Branch Managers).

AUTHENTICATED BANKER
====================
Username : {banker_username}
Role     : Branch Manager / Senior Banker

LIVE PORTFOLIO SNAPSHOT
=======================
Total Customers   : {totals.get('total_customers', 'N/A')}
Total Deposits    : ${float(totals.get('total_deposits') or 0):,.2f}
Total Loan Book   : ${float(totals.get('total_loan_book') or 0):,.2f}

CUSTOMERS BY TYPE
{cust_lines}

LOAN BOOK BY TYPE
{loan_lines}

DEPOSITS BY TYPE
{dep_lines}

REPORT CAPABILITIES
===================
You can generate and analyse the following reports on demand:

1. PORTFOLIO SUMMARY     — customer counts, deposit totals, loan book by type
2. DELINQUENCY REPORT    — past-due loans, at-risk accounts, customers with credit score < 660
3. LOAN PIPELINE         — applications by status (PENDING/APPROVED/DECLINED/UNDER_REVIEW)
4. BRANCH PERFORMANCE    — deposits, loan book, customer count per branch
5. SPENDING ANALYTICS    — transaction volume by category, channel, top merchants (last 30 days)

RESPONSE GUIDELINES
===================
- Always present data in well-formatted markdown tables where applicable
- Use $ formatting for all currency values ($1,234,567.89)
- Use % formatting for rates and percentages
- Highlight risks clearly (delinquency, low balances, pending applications)
- Suggest actionable follow-ups where relevant
- Never expose individual customer PII beyond what's needed for the report
- You can reference specific customer numbers (NBK-XXXXXXXXXX) but avoid full names in bulk reports
- Always end with a summary insight or recommendation
"""


def stream_manager_response(
    messages: List[Dict],
    banker_username: str,
    portfolio: Dict,
) -> Generator[str, None, None]:
    system_prompt = build_manager_system_prompt(banker_username, portfolio)
    anthropic_messages = [
        {"role": "user" if m["role"] == "user" else "assistant",
         "content": m["content"]}
        for m in messages
    ]
    try:
        client = _get_client()
        with client.messages.stream(
            model=Config.ANTHROPIC_MODEL,
            max_tokens=Config.ANTHROPIC_MAX_TOKENS,
            system=system_prompt,
            messages=anthropic_messages,
        ) as stream:
            for chunk in stream.text_stream:
                yield f"data: {json.dumps({'type': 'delta', 'text': chunk})}\n\n"
        yield f"data: {json.dumps({'type': 'done'})}\n\n"
    except anthropic.APIStatusError as exc:
        log.error("Manager AI error %s: %s", exc.status_code, exc.message)
        yield f"data: {json.dumps({'type': 'error', 'text': 'AI service error. Please retry.'})}\n\n"
    except Exception as exc:
        log.exception("Manager AI unexpected error: %s", exc)
        yield f"data: {json.dumps({'type': 'error', 'text': 'Unexpected error occurred.'})}\n\n"