"""
NexusBank ChatBot — Flask Application Entry Point
"""
import os
import logging
from flask import Flask, render_template
from flask_session import Session

from config.settings import Config


def create_app() -> Flask:
    app = Flask(__name__, template_folder="templates", static_folder="static")

    # ── Core config ────────────────────────────────────────────────────────────
    app.secret_key = Config.SECRET_KEY

    # ── Filesystem session MUST be configured before blueprints ───────────────
    os.makedirs("/tmp/nexusbank_sessions", exist_ok=True)
    app.config["SESSION_TYPE"]               = "filesystem"
    app.config["SESSION_FILE_DIR"]           = "/tmp/nexusbank_sessions"
    app.config["SESSION_PERMANENT"]          = False
    app.config["SESSION_USE_SIGNER"]         = True
    app.config["SESSION_COOKIE_HTTPONLY"]    = True
    app.config["SESSION_COOKIE_SAMESITE"]    = "Lax"
    app.config["PERMANENT_SESSION_LIFETIME"] = 3600
    Session(app)

    # ── Logging ────────────────────────────────────────────────────────────────
    level = getattr(logging, Config.LOG_LEVEL.upper(), logging.INFO)
    logging.basicConfig(
        level=level,
        format="%(asctime)s [%(levelname)-5s] %(name)s — %(message)s",
        datefmt="%H:%M:%S",
    )

    # ── Blueprints (imported AFTER Session is initialised) ─────────────────────
    from routes.auth_routes     import auth_bp
    from routes.main_routes     import main_bp
    from routes.manager_routes  import manager_bp
    from routes.operator_routes import operator_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(main_bp)
    app.register_blueprint(manager_bp)
    app.register_blueprint(operator_bp)

    # ── Error handlers ─────────────────────────────────────────────────────────
    @app.errorhandler(404)
    def not_found(e):
        return render_template("error.html", message="Page not found (404)"), 404

    @app.errorhandler(500)
    def server_error(e):
        return render_template("error.html", message="Internal server error (500)"), 500

    # ── Template globals ───────────────────────────────────────────────────────
    app.jinja_env.globals.update(
        app_name=Config.APP_NAME,
        app_version=Config.APP_VERSION,
    )

    return app


if __name__ == "__main__":
    application = create_app()
    application.run(
        host=Config.HOST,
        port=Config.PORT,
        debug=Config.DEBUG,
        threaded=True,
    )