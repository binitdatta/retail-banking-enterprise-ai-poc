import os
from dotenv import load_dotenv
load_dotenv()

class Config:
    SECRET_KEY            = os.getenv("FLASK_SECRET_KEY", "dev-secret-key-change-me")
    DEBUG                 = os.getenv("FLASK_DEBUG", "False").lower() == "true"
    HOST                  = os.getenv("FLASK_HOST", "0.0.0.0")
    PORT                  = int(os.getenv("FLASK_PORT", "5051"))
    KEYCLOAK_BASE_URL     = os.getenv("KEYCLOAK_BASE_URL",  "http://localhost:8080")
    KEYCLOAK_REALM        = os.getenv("KEYCLOAK_REALM",     "nexusbank")
    KEYCLOAK_CLIENT_ID    = os.getenv("KEYCLOAK_CLIENT_ID", "nexusbank-ui")
    KEYCLOAK_REDIRECT_URI = os.getenv("KEYCLOAK_REDIRECT_URI", "http://localhost:5051/auth/callback")
    ANTHROPIC_API_KEY     = os.getenv("ANTHROPIC_API_KEY",  "")
    ANTHROPIC_MODEL       = os.getenv("ANTHROPIC_MODEL",    "claude-opus-4-5-20251001")
    ANTHROPIC_MAX_TOKENS  = int(os.getenv("ANTHROPIC_MAX_TOKENS", "2048"))
    DB_HOST               = os.getenv("DB_HOST",     "localhost")
    DB_PORT               = int(os.getenv("DB_PORT", "3306"))
    DB_NAME               = os.getenv("DB_NAME",     "nexusbank_db")
    DB_USER               = os.getenv("DB_USER",     "root")
    DB_PASSWORD           = os.getenv("DB_PASSWORD", "localroot")
    DB_POOL_SIZE          = int(os.getenv("DB_POOL_SIZE",    "5"))
    DB_POOL_RECYCLE       = int(os.getenv("DB_POOL_RECYCLE", "300"))
    APP_NAME              = os.getenv("APP_NAME",    "NexusBank AI Assistant")
    APP_VERSION           = os.getenv("APP_VERSION", "1.0.0")
    LOG_LEVEL             = os.getenv("LOG_LEVEL",   "INFO")

    @classmethod
    def db_url(cls):
        return (f"mysql+pymysql://{cls.DB_USER}:{cls.DB_PASSWORD}"
                f"@{cls.DB_HOST}:{cls.DB_PORT}/{cls.DB_NAME}?charset=utf8mb4")

    @classmethod
    def keycloak_auth_url(cls):
        return f"{cls.KEYCLOAK_BASE_URL}/realms/{cls.KEYCLOAK_REALM}/protocol/openid-connect/auth"

    @classmethod
    def keycloak_token_url(cls):
        return f"{cls.KEYCLOAK_BASE_URL}/realms/{cls.KEYCLOAK_REALM}/protocol/openid-connect/token"

    @classmethod
    def keycloak_userinfo_url(cls):
        return f"{cls.KEYCLOAK_BASE_URL}/realms/{cls.KEYCLOAK_REALM}/protocol/openid-connect/userinfo"

    @classmethod
    def keycloak_logout_url(cls):
        return f"{cls.KEYCLOAK_BASE_URL}/realms/{cls.KEYCLOAK_REALM}/protocol/openid-connect/logout"

    @classmethod
    def keycloak_jwks_url(cls):
        return f"{cls.KEYCLOAK_BASE_URL}/realms/{cls.KEYCLOAK_REALM}/protocol/openid-connect/certs"
