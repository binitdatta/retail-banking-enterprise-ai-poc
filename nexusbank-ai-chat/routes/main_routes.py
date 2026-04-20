"""
NexusBank ChatBot — Main Routes
GET  /          → public home page
GET  /chat      → secured chat UI (login_required)
POST /chat/send → appends message, returns SSE stream
GET  /api/accounts    → JSON accounts list
GET  /api/loans       → JSON loans list
GET  /api/alerts      → JSON unread alerts
GET  /api/transactions → JSON recent transactions
GET  /chat/clear      → clear conversation history
"""
from __future__ import annotations

import json
import logging

from flask import (Blueprint, Response, jsonify, render_template,
                   request, session, stream_with_context)

from services import ai_service as ai
from services import db_service as db
from utils.decorators import login_required

log = logging.getLogger(__name__)
main_bp = Blueprint("main", __name__)


# ── Public home ───────────────────────────────────────────────────────────────

@main_bp.route("/")
def index():
    return render_template("home.html")


# ── Chat UI ───────────────────────────────────────────────────────────────────

@main_bp.route("/chat")
@login_required
def chat():
    # Always go to customer chat — manager/operator accessed directly via URL
    customer = session["customer"]
    alerts   = db.get_unread_alerts(customer["customer_id"])
    accounts = db.get_accounts_for_customer(customer["customer_id"])
    history  = session.get("chat_history", [])
    return render_template(
        "chat.html",
        customer=customer,
        alerts=alerts,
        accounts=accounts,
        history=history,
    )


# ── SSE streaming endpoint ────────────────────────────────────────────────────

@main_bp.route("/chat/send", methods=["POST"])
@login_required
def chat_send():
    data        = request.get_json(force=True)
    user_msg    = (data.get("message") or "").strip()
    if not user_msg:
        return jsonify({"error": "Empty message"}), 400

    customer = session["customer"]
    cid      = customer["customer_id"]

    # ── Display history (shown in UI) ─────────────────────────────────────────
    display_history = session.get("chat_history", [])
    display_history.append({"role": "user", "content": user_msg})
    session["chat_history"] = display_history[-40:]

    # ── Claude only gets the single current question — fresh context every time
    # This prevents prior answers bleeding into the next response.
    # The system prompt already has all live account data so Claude needs
    # no conversation history to answer accurately.
    claude_messages = [{"role": "user", "content": user_msg}]

    # Build live financial context fresh for this request
    financial_ctx = db.build_financial_context(cid)

    def generate():
        full_reply = []
        for chunk in ai.stream_chat_response(claude_messages, customer, financial_ctx):
            yield chunk
            try:
                payload = chunk.replace("data: ", "", 1).strip()
                event   = json.loads(payload)
                if event.get("type") == "delta":
                    full_reply.append(event["text"])
            except Exception:
                pass

        # Store reply in display history only (not sent back to Claude)
        hist = session.get("chat_history", [])
        hist.append({"role": "assistant", "content": "".join(full_reply)})
        session["chat_history"] = hist[-40:]
        session.modified = True

    return Response(
        stream_with_context(generate()),
        mimetype="text/event-stream",
        headers={
            "Cache-Control":        "no-cache",
            "X-Accel-Buffering":    "no",
            "Connection":           "keep-alive",
        },
    )


# ── Clear chat ────────────────────────────────────────────────────────────────

@main_bp.route("/chat/clear")
@login_required
def chat_clear():
    session["chat_history"] = []
    session.modified = True
    return jsonify({"status": "cleared"})


# ── API: Accounts ─────────────────────────────────────────────────────────────

@main_bp.route("/api/accounts")
@login_required
def api_accounts():
    cid      = session["customer"]["customer_id"]
    accounts = db.get_accounts_for_customer(cid)
    return jsonify(_serialise(accounts))


# ── API: Loans ────────────────────────────────────────────────────────────────

@main_bp.route("/api/loans")
@login_required
def api_loans():
    cid   = session["customer"]["customer_id"]
    loans = db.get_loans_for_customer(cid)
    return jsonify(_serialise(loans))


# ── API: Alerts ───────────────────────────────────────────────────────────────

@main_bp.route("/api/alerts")
@login_required
def api_alerts():
    cid    = session["customer"]["customer_id"]
    alerts = db.get_unread_alerts(cid)
    return jsonify(_serialise(alerts))


# ── API: Transactions ─────────────────────────────────────────────────────────

@main_bp.route("/api/transactions")
@login_required
def api_transactions():
    cid  = session["customer"]["customer_id"]
    limit = min(int(request.args.get("limit", 20)), 100)
    txns = db.get_recent_transactions(cid, limit)
    return jsonify(_serialise(txns))


# ── API: Cards ────────────────────────────────────────────────────────────────

@main_bp.route("/api/cards")
@login_required
def api_cards():
    cid   = session["customer"]["customer_id"]
    cards = db.get_cards_for_customer(cid)
    return jsonify(_serialise(cards))


# ── Health check ──────────────────────────────────────────────────────────────

@main_bp.route("/health")
def health():
    return jsonify({"status": "ok", "service": "nexusbank-chatbot"})


# ── Utility ───────────────────────────────────────────────────────────────────

def _serialise(rows):
    """Convert Decimal/date objects to JSON-safe types."""
    import decimal, datetime
    def convert(obj):
        if isinstance(obj, decimal.Decimal):
            return float(obj)
        if isinstance(obj, (datetime.date, datetime.datetime)):
            return obj.isoformat()
        return obj

    return [
        {k: convert(v) for k, v in row.items()}
        for row in rows
    ]