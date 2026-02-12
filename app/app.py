from flask import Flask, jsonify, request
import logging
import os
import sys
from datetime import datetime

app = Flask(__name__)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Get environment variables
ENVIRONMENT = os.getenv("ENVIRONMENT", "unknown")
APP_VERSION = os.getenv("APP_VERSION", "unknown")
INSTRUMENTATION_KEY = os.getenv("APPINSIGHTS_INSTRUMENTATIONKEY", "")

# Log application startup
logger.info(f"=== Starting DevOps Demo App ===")
logger.info(f"Environment: {ENVIRONMENT}")
logger.info(f"Version: {APP_VERSION}")
logger.info(f"Application Insights: {'Enabled' if INSTRUMENTATION_KEY else 'Disabled'}")

@app.before_request
def log_request_info():
    """Log incoming request details"""
    logger.info(f"Request: {request.method} {request.path} - IP: {request.remote_addr}")

@app.after_request
def log_response_info(response):
    """Log response details"""
    logger.info(f"Response: {request.method} {request.path} - Status: {response.status_code}")
    return response

@app.get("/health")
def health():
    """Health check endpoint with detailed status"""
    logger.info("Health check endpoint called")
    
    health_status = {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "environment": ENVIRONMENT,
        "version": APP_VERSION,
        "checks": {
            "application": "ok",
            "logging": "ok",
            "app_insights": "enabled" if INSTRUMENTATION_KEY else "disabled"
        }
    }
    
    logger.info(f"Health check result: {health_status['status']}")
    return jsonify(health_status), 200

@app.get("/")
def home():
    """Home endpoint"""
    logger.info("Home endpoint accessed")
    return jsonify({
        "message": "DevOps Demo App is running!",
        "environment": ENVIRONMENT,
        "version": APP_VERSION,
        "endpoints": {
            "health": "/health",
            "home": "/",
            "info": "/info"
        }
    }), 200

@app.get("/info")
def info():
    """Application information endpoint"""
    logger.info("Info endpoint accessed")
    return jsonify({
        "application": "DevOps Demo App",
        "environment": ENVIRONMENT,
        "version": APP_VERSION,
        "python_version": sys.version,
        "monitoring": {
            "application_insights": "enabled" if INSTRUMENTATION_KEY else "disabled",
            "logging_level": logging.getLevelName(logger.level)
        }
    }), 200

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    logger.warning(f"404 Not Found: {request.path}")
    return jsonify({
        "error": "Not Found",
        "message": f"The requested URL {request.path} was not found",
        "status_code": 404
    }), 404

@app.errorhandler(Exception)
def handle_exception(e):
    """Handle all unhandled exceptions"""
    logger.error(f"Unhandled exception: {str(e)}", exc_info=True)
    return jsonify({
        "error": "Internal Server Error",
        "message": "An unexpected error occurred",
        "status_code": 500
    }), 500

if __name__ == "__main__":
    logger.info("Starting Flask application on host 0.0.0.0 port 3000")
    app.run(host="0.0.0.0", port=3000, debug=False)
