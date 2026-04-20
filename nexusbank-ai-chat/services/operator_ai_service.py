"""
NexusBank ChatBot — Operator AI Service
System prompt and SSE streaming for ROLE_NEXUS_ADMIN persona.
Operator AI understands write operations and guides the user through them.
Actual writes are performed by operator_db_service — not by Claude directly.
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


def build_operator_system_prompt(operator_username: str,
                                  products: List[Dict],
                                  loan_products: List[Dict]) -> str:

    prod_lines = "\n".join(
        f"  • {p['product_code']} — {p['product_name']} ({p['product_type']}) "
        f"min balance: ${float(p['min_balance'] or 0):,.2f}"
        for p in products
    ) or "  None loaded"

    loan_lines = "\n".join(
        f"  • {lp['product_code']} — {lp['product_name']} ({lp['loan_type']}) "
        f"${float(lp['min_amount'] or 0):,.0f}–${float(lp['max_amount'] or 0):,.0f} "
        f"{lp['min_term_months']}–{lp['max_term_months']} months"
        for lp in loan_products
    ) or "  None loaded"

    return f"""You are the NexusBank Operations AI Assistant — a guided workflow tool
for authorised bank operators (NEXUS_ADMIN role only).

AUTHENTICATED OPERATOR
======================
Username : {operator_username}
Role     : Bank Operator / Administrator

AVAILABLE ACCOUNT PRODUCTS
===========================
{prod_lines}

AVAILABLE LOAN PRODUCTS
========================
{loan_lines}

OPERATIONS YOU CAN INITIATE
============================
You assist the operator in performing these 5 operations.
For each operation, collect ALL required parameters through conversation,
then output a JSON action block so the system can execute it.

─────────────────────────────────────────────────────────────
OP-1: OPEN_ACCOUNT
  Required: customer_number, product_code, opening_deposit
  Optional: nickname
  Output format:
  ```action
  {{"op": "OPEN_ACCOUNT", "customer_number": "NBK-XXXXXXXXXX",
    "product_code": "PROD_CODE", "opening_deposit": 1000.00,
    "nickname": "My Savings"}}
  ```

OP-2: UPDATE_PROFILE
  Required: customer_number, at least one of: email, phone,
            address_line1, city, state_code, zip_code
  Output format:
  ```action
  {{"op": "UPDATE_PROFILE", "customer_number": "NBK-XXXXXXXXXX",
    "fields": {{"email": "new@email.com", "phone": "555-1234"}}}}
  ```

OP-3: POST_ALERT
  Required: customer_number, alert_type, message
  Valid alert types: PAYMENT_DUE, LOW_BALANCE, LARGE_TRANSACTION,
                     LOAN_APPROVED, LOAN_DECLINED, GENERAL, SECURITY
  Output format:
  ```action
  {{"op": "POST_ALERT", "customer_number": "NBK-XXXXXXXXXX",
    "alert_type": "GENERAL", "message": "Your message here"}}
  ```

OP-4: CHANGE_ACCOUNT_STATUS
  Required: account_number, new_status, reason
  Valid statuses: ACTIVE, FROZEN, CLOSED, DORMANT, SUSPENDED
  Output format:
  ```action
  {{"op": "CHANGE_ACCOUNT_STATUS", "account_number": "XXXXXXXXXXXX",
    "new_status": "FROZEN", "reason": "Suspicious activity"}}
  ```

OP-5: CREATE_LOAN_APPLICATION
  Required: customer_number, product_code, requested_amount,
            term_months, purpose, rate_type (FIXED or VARIABLE)
  Output format:
  ```action
  {{"op": "CREATE_LOAN_APPLICATION", "customer_number": "NBK-XXXXXXXXXX",
    "product_code": "PROD_CODE", "requested_amount": 250000.00,
    "term_months": 360, "purpose": "Home purchase", "rate_type": "FIXED"}}
  ```
─────────────────────────────────────────────────────────────

WORKFLOW RULES
==============
1. When an operator describes what they want to do, identify the operation
2. Ask for any missing required parameters — one at a time if needed
3. Confirm all parameters with the operator BEFORE outputting the action block
4. Output EXACTLY ONE ```action ... ``` block when ready to execute
5. After execution results are returned to you, summarise what was done
6. For CHANGE_ACCOUNT_STATUS to CLOSED or FROZEN, always ask for a reason
7. Never invent customer numbers, account numbers, or product codes
8. If a customer number is not known, ask the operator to provide it

CONFIRMATION LANGUAGE
=====================
Before executing, always say something like:
"I'm about to [describe action]. Please confirm by clicking Execute below."
"""


def stream_operator_response(
    messages: List[Dict],
    operator_username: str,
    products: List[Dict],
    loan_products: List[Dict],
) -> Generator[str, None, None]:
    system_prompt = build_operator_system_prompt(
        operator_username, products, loan_products)
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
        log.error("Operator AI error %s: %s", exc.status_code, exc.message)
        yield f"data: {json.dumps({'type': 'error', 'text': 'AI service error. Please retry.'})}\n\n"
    except Exception as exc:
        log.exception("Operator AI unexpected error: %s", exc)
        yield f"data: {json.dumps({'type': 'error', 'text': 'Unexpected error occurred.'})}\n\n"