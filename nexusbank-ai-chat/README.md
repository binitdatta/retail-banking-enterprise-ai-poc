# NexusBank AI ChatBot

Python 3.12 · Flask 3.x · Keycloak 26 PKCE · Anthropic Claude · SQLAlchemy · Bootstrap 5 Dark

## Architecture

```
nexusbank-chatbot/
├── app.py                     # Flask factory + entry point
├── wsgi.py                    # gunicorn WSGI entry
├── requirements.txt
├── .env.template              # copy → .env and fill in values
│
├── config/
│   └── settings.py            # All config from .env
│
├── routes/
│   ├── auth_routes.py         # /auth/login /auth/callback /auth/logout
│   └── main_routes.py         # / /chat /chat/send /api/* /health
│
├── services/
│   ├── auth_service.py        # Keycloak PKCE helpers
│   ├── db_service.py          # SQLAlchemy direct reads (nexusbank_db)
│   └── ai_service.py          # Anthropic Claude SSE streaming
│
├── utils/
│   └── decorators.py          # @login_required @banker_required
│
├── templates/
│   ├── base.html              # Bootstrap 5 Dark navbar + footer
│   ├── home.html              # Public landing page
│   ├── chat.html              # Secured chat UI with SSE
│   └── error.html             # Error page
│
└── static/
    └── css/
        └── nexusbank.css      # Full dark theme
```

## Quick Start

```bash
cd nexusbank-chatbot
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
cp .env.template .env          # fill in ANTHROPIC_API_KEY, DB creds, Keycloak
python app.py                  # dev server on http://localhost:5050
```

## Production

```bash
gunicorn --chdir /Users/binit.datta/Development/retail-banking-enterprise-ai-poc/nexusbank-ai-chat \
         --bind 0.0.0.0:5051 \
         --workers 2 \
         --threads 4 \
         wsgi:application
 ```

## Prerequisites

| Service  | Version | Detail |
|----------|---------|--------|
| Python   | 3.12    | |
| MySQL    | 8.x     | nexusbank_db with seed data loaded |
| Keycloak | 26      | realm: `nexusbank`, client: `nexusbank-ui` (public/PKCE) |

## Keycloak Client Setup

- Client ID: `nexusbank-ui`
- Access Type: **public** (no client secret)
- Valid Redirect URI: `http://localhost:5050/auth/callback`
- PKCE Challenge Method: **S256**

## Security

- PKCE (S256) — no client secret ever touches the browser
- Server-side OAuth state validation (no cookie-based state)
- Session-scoped financial context — each request loads fresh data
- AI cannot execute any financial transactions
- All DB reads are customer-scoped (keycloak_user_id → customer_id)

``` 
-1. source venv/bin/activate
-2. gunicorn wsgi:application
```

## Disclaimer

This repository is a proof-of-concept created for demonstration, experimentation, and learning purposes only.

All database records, customer profiles, names, addresses, emails, phone numbers, account details, loan data, transactions, and related information included in this repository are synthetic and fictitious. The data was generated for demo purposes and is not derived from real customers, real financial accounts, or real business activity.

Any resemblance to actual persons, organizations, financial accounts, addresses, or events is purely coincidental.

No production data, confidential business data, or live customer information is intended to be contained in this repository.

### Demo Data Notice

The included `db-dump.sql` file contains synthetic demo data only. It is provided solely to help run and demonstrate the proof-of-concept locally.