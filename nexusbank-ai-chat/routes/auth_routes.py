"""
NexusBank ChatBot — Auth Routes
Uses a signed state token that round-trips through Keycloak
instead of relying on session cookies surviving the redirect.
"""
from __future__ import annotations
import hashlib
import hmac
import json
import logging
import time
import base64

from flask import (Blueprint, redirect, render_template,
                   request, session, url_for)

from config.settings import Config
from services import auth_service as svc
from services import db_service   as db

log = logging.getLogger(__name__)
auth_bp = Blueprint("auth", __name__, url_prefix="/auth")

# ── Sign/verify state payload so verifier round-trips safely ─────────────────

def _encode_state(state: str, verifier: str) -> str:
    payload = json.dumps({"s": state, "v": verifier, "t": int(time.time())})
    encoded = base64.urlsafe_b64encode(payload.encode()).decode()
    sig = hmac.new(Config.SECRET_KEY.encode(), encoded.encode(), hashlib.sha256).hexdigest()[:16]
    return f"{encoded}.{sig}"

def _decode_state(token: str):
    try:
        encoded, sig = token.rsplit(".", 1)
        expected = hmac.new(Config.SECRET_KEY.encode(), encoded.encode(), hashlib.sha256).hexdigest()[:16]
        if not hmac.compare_digest(sig, expected):
            return None, None
        payload = json.loads(base64.urlsafe_b64decode(encoded).decode())
        if int(time.time()) - payload["t"] > 600:   # 10-minute expiry
            return None, None
        return payload["s"], payload["v"]
    except Exception:
        return None, None


@auth_bp.route("/login")
def login():
    verifier, challenge = svc.generate_pkce_pair()
    state = svc.generate_state()
    # Encode verifier INTO the state token — no session needed
    state_token = _encode_state(state, verifier)
    auth_url = svc.build_auth_url(state_token, challenge)
    log.info("LOGIN auth_url: %s", auth_url)
    return redirect(auth_url)


@auth_bp.route("/callback")
def callback():
    code        = request.args.get("code")
    state_token = request.args.get("state")
    error       = request.args.get("error")

    if error:
        log.warning("Keycloak error: %s", error)
        return render_template("error.html",
                               message=f"Authentication error: {error}"), 400

    # Decode state — verifier is embedded, no session needed
    state, verifier = _decode_state(state_token or "")
    if not state or not verifier:
        log.warning("Invalid or expired state token")
        return render_template("error.html",
                               message="Invalid state parameter. Please try again."), 400

    tokens = svc.exchange_code_for_tokens(code, verifier)
    if not tokens:
        return render_template("error.html",
                               message="Token exchange failed. Please try again."), 500

    userinfo = svc.get_userinfo(tokens["access_token"])
    if not userinfo:
        return render_template("error.html",
                               message="Could not fetch user profile."), 500

    kc_uid = userinfo.get("sub")
    log.info("Authenticated: %s (%s)", userinfo.get("preferred_username"), kc_uid)

    customer = db.get_customer_by_keycloak_id(kc_uid)
    if not customer:
        log.warning("No customer for keycloak_user_id=%s", kc_uid)
        return render_template("error.html",
                               message="Your account is not registered. Please contact support."), 403

    realm_roles = userinfo.get("realm_access", {}).get("roles", [])
    roles = [f"ROLE_{r}" for r in realm_roles
             if r in ("NEXUS_ADMIN", "NEXUS_BANKER", "NEXUS_USER")]

    session.permanent = True
    session["customer"]     = customer
    session["access_token"] = tokens["access_token"]
    session["refresh_token"]= tokens.get("refresh_token")
    session["id_token"]     = tokens.get("id_token")
    session["roles"]        = roles
    session["kc_username"]  = userinfo.get("preferred_username")
    session["chat_history"] = []
    session.modified = True

    return redirect(url_for("main.chat"))


@auth_bp.route("/logout")
def logout():
    id_token = session.get("id_token")
    session.clear()
    if id_token:
        post_redirect = url_for("main.index", _external=True)
        return redirect(svc.build_logout_url(id_token, post_redirect))
    return redirect(url_for("main.index"))