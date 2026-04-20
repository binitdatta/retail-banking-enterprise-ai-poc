"""
NexusBank ChatBot — Operator Routes
/operator/          → operator chat UI
/operator/chat/send → SSE streaming
/operator/execute   → executes confirmed write operations
"""
from __future__ import annotations

import json
import logging
import re

from flask import (Blueprint, Response, jsonify, render_template,
                   request, session, stream_with_context)

from services import operator_ai_service as ai
from services import operator_db_service as db
from services import manager_db_service  as mdb
from utils.decorators import login_required, admin_required

log = logging.getLogger(__name__)
operator_bp = Blueprint("operator", __name__, url_prefix="/operator")


# ── Operator chat UI ──────────────────────────────────────────────────────────

@operator_bp.route("/")
@login_required
@admin_required
def chat():
    products      = db.get_account_products()
    loan_products = db.get_loan_products()
    history       = session.get("operator_chat_history", [])
    return render_template(
        "operator_chat.html",
        operator_username=session.get("kc_username", "Operator"),
        products=products,
        loan_products=loan_products,
        history=history,
    )


# ── SSE streaming ─────────────────────────────────────────────────────────────

@operator_bp.route("/chat/send", methods=["POST"])
@login_required
@admin_required
def chat_send():
    data = request.get_json(force=True)
    msg  = (data.get("message") or "").strip()
    if not msg:
        return jsonify({"error": "Empty message"}), 400

    history = session.get("operator_chat_history", [])
    history.append({"role": "user", "content": msg})
    session["operator_chat_history"] = history[-40:]

    products      = db.get_account_products()
    loan_products = db.get_loan_products()
    operator      = session.get("kc_username", "Operator")

    def generate():
        full = []
        for chunk in ai.stream_operator_response(
                history, operator, products, loan_products):
            yield chunk
            try:
                ev = json.loads(chunk.replace("data: ", "", 1).strip())
                if ev.get("type") == "delta":
                    full.append(ev["text"])
            except Exception:
                pass

        reply = "".join(full)
        hist  = session.get("operator_chat_history", [])
        hist.append({"role": "assistant", "content": reply})
        session["operator_chat_history"] = hist[-40:]

        # Check if AI embedded an action block — signal the UI
        if "```action" in reply:
            action_json = _extract_action(reply)
            if action_json:
                session["pending_action"] = action_json
        session.modified = True

    return Response(
        stream_with_context(generate()),
        mimetype="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@operator_bp.route("/chat/clear")
@login_required
@admin_required
def chat_clear():
    session["operator_chat_history"] = []
    session.pop("pending_action", None)
    session.modified = True
    return jsonify({"status": "cleared"})


# ── Execute confirmed operation ───────────────────────────────────────────────

@operator_bp.route("/execute", methods=["POST"])
@login_required
@admin_required
def execute():
    """
    Called when operator clicks 'Execute' confirmation button.
    Reads pending_action from session and dispatches to db service.
    """
    action = session.pop("pending_action", None)
    if not action:
        # Try reading from request body as fallback
        body   = request.get_json(force=True)
        action = body.get("action")

    if not action:
        return jsonify({"success": False, "error": "No pending action found."}), 400

    operator = session.get("kc_username", "operator")
    op       = action.get("op")
    result   = {}

    try:
        if op == "OPEN_ACCOUNT":
            cust = mdb.get_customer_by_number(action["customer_number"])
            if not cust:
                return jsonify({"success": False,
                                "error": f"Customer {action['customer_number']} not found."})
            result = db.open_account(
                customer_id      = cust["customer_id"],
                product_code     = action["product_code"],
                nickname         = action.get("nickname"),
                opening_deposit  = float(action["opening_deposit"]),
                operator_username= operator,
            )

        elif op == "UPDATE_PROFILE":
            cust = mdb.get_customer_by_number(action["customer_number"])
            if not cust:
                return jsonify({"success": False,
                                "error": f"Customer {action['customer_number']} not found."})
            result = db.update_customer_profile(
                customer_id      = cust["customer_id"],
                fields           = action.get("fields", {}),
                operator_username= operator,
            )

        elif op == "POST_ALERT":
            cust = mdb.get_customer_by_number(action["customer_number"])
            if not cust:
                return jsonify({"success": False,
                                "error": f"Customer {action['customer_number']} not found."})
            result = db.post_customer_alert(
                customer_id      = cust["customer_id"],
                alert_type       = action.get("alert_type", "GENERAL"),
                message          = action["message"],
                operator_username= operator,
            )

        elif op == "CHANGE_ACCOUNT_STATUS":
            acct = _find_account_by_number(action["account_number"])
            if not acct:
                return jsonify({"success": False,
                                "error": f"Account {action['account_number']} not found."})
            result = db.change_account_status(
                account_id       = acct["account_id"],
                new_status       = action["new_status"],
                reason           = action.get("reason", "Operator request"),
                operator_username= operator,
            )

        elif op == "CREATE_LOAN_APPLICATION":
            cust = mdb.get_customer_by_number(action["customer_number"])
            if not cust:
                return jsonify({"success": False,
                                "error": f"Customer {action['customer_number']} not found."})
            result = db.create_loan_application(
                customer_id      = cust["customer_id"],
                product_code     = action["product_code"],
                requested_amount = float(action["requested_amount"]),
                term_months      = int(action["term_months"]),
                purpose          = action.get("purpose", ""),
                rate_type        = action.get("rate_type", "FIXED"),
                operator_username= operator,
            )

        else:
            return jsonify({"success": False, "error": f"Unknown operation: {op}"}), 400

    except Exception as exc:
        log.exception("Execute error for op=%s: %s", op, exc)
        return jsonify({"success": False, "error": str(exc)}), 500

    # Append execution result into chat history so AI knows what happened
    if result.get("success"):
        hist = session.get("operator_chat_history", [])
        hist.append({
            "role": "user",
            "content": f"[SYSTEM] Operation {op} executed successfully. Result: {json.dumps(result)}"
        })
        session["operator_chat_history"] = hist
        session.modified = True

    return jsonify(result)


# ── Helpers ───────────────────────────────────────────────────────────────────

def _extract_action(text: str):
    """Pull JSON from ```action ... ``` block in AI response."""
    match = re.search(r"```action\s*(\{.*?\})\s*```", text, re.DOTALL)
    if match:
        try:
            return json.loads(match.group(1))
        except Exception:
            pass
    return None


def _find_account_by_number(account_number: str):
    from services.db_service import _one
    return _one(
        "SELECT account_id, account_number, account_status FROM accounts WHERE account_number = :an",
        {"an": account_number},
    )