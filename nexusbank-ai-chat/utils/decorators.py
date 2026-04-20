"""
NexusBank ChatBot — Route Decorators
"""
from __future__ import annotations

import logging
from functools import wraps

from flask import redirect, request, session, url_for

log = logging.getLogger(__name__)


def login_required(fn):
    """Redirect to /auth/login if no valid session."""
    @wraps(fn)
    def wrapper(*args, **kwargs):
        if not session.get("customer"):
            log.debug("Unauthenticated access to %s — redirecting to login", request.path)
            session["next_url"] = request.url
            return redirect(url_for("auth.login"))
        return fn(*args, **kwargs)
    return wrapper


def banker_required(fn):
    """Only ROLE_NEXUS_BANKER or ROLE_NEXUS_ADMIN may access."""
    @wraps(fn)
    def wrapper(*args, **kwargs):
        roles = session.get("roles", [])
        if "ROLE_NEXUS_BANKER" not in roles and "ROLE_NEXUS_ADMIN" not in roles:
            return redirect(url_for("main.index"))
        return fn(*args, **kwargs)
    return wrapper


def admin_required(fn):
    """Only ROLE_NEXUS_ADMIN may access."""
    @wraps(fn)
    def wrapper(*args, **kwargs):
        roles = session.get("roles", [])
        if "ROLE_NEXUS_ADMIN" not in roles:
            return redirect(url_for("main.index"))
        return fn(*args, **kwargs)
    return wrapper