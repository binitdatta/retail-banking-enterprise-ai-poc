"""
NexusBank ChatBot — Manager Routes
/manager/          → manager chat UI
/manager/chat/send → SSE streaming with report data injection
/manager/reports/* → JSON report endpoints
"""
from __future__ import annotations

import json
import logging

from flask import (Blueprint, Response, jsonify, render_template,
                   request, session, stream_with_context)

from services import manager_ai_service as ai
from services import manager_db_service as db
from utils.decorators import login_required, banker_required

log = logging.getLogger(__name__)
manager_bp = Blueprint("manager", __name__, url_prefix="/manager")


@manager_bp.route("/")
@login_required
@banker_required
def chat():
    portfolio = db.get_portfolio_summary()
    history   = session.get("manager_chat_history", [])
    return render_template(
        "manager_chat.html",
        banker_username=session.get("kc_username", "Banker"),
        portfolio=portfolio,
        history=history,
    )


@manager_bp.route("/chat/send", methods=["POST"])
@login_required
@banker_required
def chat_send():
    body = request.get_json(force=True)
    msg  = (body.get("message") or "").strip()
    if not msg:
        return jsonify({"error": "Empty message"}), 400

    history   = session.get("manager_chat_history", [])
    msg_lower = msg.lower()

    report_context = _detect_and_fetch_report(msg_lower)
    user_content   = msg
    if report_context:
        user_content = msg + "\n\nHere is the live data for this report:\n" + report_context

    history.append({"role": "user", "content": user_content})
    session["manager_chat_history"] = history[-40:]

    portfolio = db.get_portfolio_summary()
    banker    = session.get("kc_username", "Banker")

    def generate():
        full = []
        for chunk in ai.stream_manager_response(history, banker, portfolio):
            yield chunk
            try:
                ev = json.loads(chunk.replace("data: ", "", 1).strip())
                if ev.get("type") == "delta":
                    full.append(ev["text"])
            except Exception:
                pass
        hist = session.get("manager_chat_history", [])
        if hist and hist[-1]["role"] == "user":
            hist[-1] = {"role": "user", "content": msg}
        hist.append({"role": "assistant", "content": "".join(full)})
        session["manager_chat_history"] = hist[-40:]
        session.modified = True

    return Response(
        stream_with_context(generate()),
        mimetype="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@manager_bp.route("/chat/clear")
@login_required
@banker_required
def chat_clear():
    session["manager_chat_history"] = []
    session.modified = True
    return jsonify({"status": "cleared"})


def _detect_and_fetch_report(msg_lower: str) -> str:
    if any(w in msg_lower for w in [
            "delinquen", "past due", "at-risk", "overdue", "late payment",
            "days past", "missed payment"]):
        rows = db.get_delinquency_report()
        low  = db.get_low_balance_alerts()
        return (
            "[DELINQUENCY REPORT]\n" + json.dumps(_s(rows), indent=2) +
            "\n[LOW BALANCE ALERTS]\n" + json.dumps(_s(low), indent=2)
        )

    if any(w in msg_lower for w in [
            "pipeline", "application", "pending", "approved", "declined",
            "under review", "loan request"]):
        rows   = db.get_loan_pipeline()
        status = db.get_pipeline_by_status()
        return (
            "[LOAN PIPELINE]\n" + json.dumps(_s(rows), indent=2) +
            "\n[BY STATUS]\n" + json.dumps(_s(status), indent=2)
        )

    if any(w in msg_lower for w in [
            "branch", "location", "region", "office"]):
        rows = db.get_branch_performance()
        return "[BRANCH PERFORMANCE]\n" + json.dumps(_s(rows), indent=2)

    if any(w in msg_lower for w in [
            "spend", "categor", "merchant", "channel", "transaction volume"]):
        data = db.get_spending_analytics()
        return "[SPENDING ANALYTICS]\n" + json.dumps(_s(data), indent=2)

    if any(w in msg_lower for w in [
            "portfolio", "summary", "overview", "total customer",
            "total deposit", "loan book", "aum", "assets"]):
        port = db.get_portfolio_summary()
        return "[PORTFOLIO SUMMARY]\n" + json.dumps(_s(port), indent=2)

    return ""


@manager_bp.route("/reports/portfolio")
@login_required
@banker_required
def report_portfolio():
    return jsonify(_s(db.get_portfolio_summary()))


@manager_bp.route("/reports/delinquency")
@login_required
@banker_required
def report_delinquency():
    return jsonify(_s(db.get_delinquency_report()))


@manager_bp.route("/reports/pipeline")
@login_required
@banker_required
def report_pipeline():
    return jsonify({
        "applications": _s(db.get_loan_pipeline()),
        "by_status":    _s(db.get_pipeline_by_status()),
    })


@manager_bp.route("/reports/branches")
@login_required
@banker_required
def report_branches():
    return jsonify(_s(db.get_branch_performance()))


@manager_bp.route("/reports/spending")
@login_required
@banker_required
def report_spending():
    return jsonify(_s(db.get_spending_analytics()))


def _s(data):
    import decimal, datetime
    def c(v):
        if isinstance(v, decimal.Decimal): return float(v)
        if isinstance(v, (datetime.date, datetime.datetime)): return v.isoformat()
        return v
    if isinstance(data, list):
        return [{k: c(v) for k, v in row.items()} for row in data]
    if isinstance(data, dict):
        return {k: (_s(v) if isinstance(v, (list, dict)) else c(v)) for k, v in data.items()}
    return data