"""
NexusBank ChatBot — Keycloak PKCE Authentication Service
Implements full Authorization Code + PKCE flow (no client secret).
State stored server-side in Flask session (not cookies) to prevent CSRF.
"""
from __future__ import annotations

import base64
import hashlib
import logging
import os
import secrets
from typing import Dict, Optional, Tuple

import requests

from config.settings import Config

from urllib.parse import urlencode

log = logging.getLogger(__name__)


# ── PKCE Helpers ──────────────────────────────────────────────────────────────

def generate_pkce_pair() -> Tuple[str, str]:
    """Return (code_verifier, code_challenge)."""
    verifier  = secrets.token_urlsafe(64)
    digest    = hashlib.sha256(verifier.encode()).digest()
    challenge = base64.urlsafe_b64encode(digest).rstrip(b"=").decode()
    return verifier, challenge


def generate_state() -> str:
    return secrets.token_urlsafe(32)


# ── Build authorization URL ───────────────────────────────────────────────────

def build_auth_url(state: str, code_challenge: str) -> str:
    params = {
        "client_id": Config.KEYCLOAK_CLIENT_ID,
        "response_type": "code",
        "scope": "openid profile email",
        "redirect_uri": Config.KEYCLOAK_REDIRECT_URI,
        "state": state,
        "code_challenge": code_challenge,
        "code_challenge_method": "S256",
    }
    return f"{Config.keycloak_auth_url()}?{urlencode(params)}"


# ── Exchange code for tokens ──────────────────────────────────────────────────

def exchange_code_for_tokens(code: str, code_verifier: str) -> Optional[Dict]:
    payload = {
        "grant_type":    "authorization_code",
        "client_id":     Config.KEYCLOAK_CLIENT_ID,
        "code":          code,
        "redirect_uri":  Config.KEYCLOAK_REDIRECT_URI,
        "code_verifier": code_verifier,
    }
    try:
        resp = requests.post(Config.keycloak_token_url(), data=payload, timeout=10)
        resp.raise_for_status()
        return resp.json()
    except Exception as exc:
        log.error("Token exchange failed: %s", exc)
        return None


# ── Fetch userinfo ────────────────────────────────────────────────────────────

def get_userinfo(access_token: str) -> Optional[Dict]:
    headers = {"Authorization": f"Bearer {access_token}"}
    try:
        resp = requests.get(Config.keycloak_userinfo_url(), headers=headers, timeout=10)
        resp.raise_for_status()
        return resp.json()
    except Exception as exc:
        log.error("Userinfo fetch failed: %s", exc)
        return None


# ── Token refresh ─────────────────────────────────────────────────────────────

def refresh_access_token(refresh_token: str) -> Optional[Dict]:
    payload = {
        "grant_type":    "refresh_token",
        "client_id":     Config.KEYCLOAK_CLIENT_ID,
        "refresh_token": refresh_token,
    }
    try:
        resp = requests.post(Config.keycloak_token_url(), data=payload, timeout=10)
        resp.raise_for_status()
        return resp.json()
    except Exception as exc:
        log.error("Token refresh failed: %s", exc)
        return None


# ── Logout URL ────────────────────────────────────────────────────────────────

def build_logout_url(id_token_hint: str, post_logout_redirect: str) -> str:
    return (
        f"{Config.keycloak_logout_url()}"
        f"?id_token_hint={id_token_hint}"
        f"&post_logout_redirect_uri={post_logout_redirect}"
        f"&client_id={Config.KEYCLOAK_CLIENT_ID}"
    )
