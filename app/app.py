from flask import Flask, jsonify, request
import logging
import os
import sys

app = Flask(__name__)

# Basic logging to stdout (Azure App Service collects this automatically)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)

logger = logging.getLogger(__name__)

# Environment variables (set from Terraform App Service settings)
ENVIRONMENT = os.getenv("ENVIRONMENT", "unknown")
APP_VERSION = os.getenv("APP_VERSION", "unknown")

logger.info("===================================")
logger.info("Starting DevOps Demo Application")
logger.info(f"Environment: {ENVIRONMENT}")
logger.info(f"Version: {APP_VERSION}")
logger.info("===================================")

@app.before_request
def log_request():
    logger.info(f"Request: {request.method} {request.path}")

@app.after_request
def log_response(response):
    logger.info(f"Response: {response.status_code}")
    return response

@app.get("/health")
def health():
    return jsonify({"status": "ok"}), 200

@app.get("/")
def home():
    return jsonify({
        "message": "DevOps Demo App is running",
        "environment": ENVIRONMENT,
        "version": APP_VERSION
    }), 200

@app.get("/info")
def info():
    return jsonify({
        "application": "DevOps Demo App",
        "environment": ENVIRONMENT,
        "version": APP_VERSION,
        "python_version": sys.version
    }), 200

@app.errorhandler(Exception)
def handle_exception(e):
    logger.error(str(e))
    return jsonify({
        "error": "Internal Server Error"
    }), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
