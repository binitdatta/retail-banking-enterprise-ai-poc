import sys
sys.path.insert(0, '/Users/binit.datta/Development/retail-banking-enterprise-ai-poc/nexusbank-ai-chat')

from app import create_app
application = create_app()

if __name__ == "__main__":
    application.run()