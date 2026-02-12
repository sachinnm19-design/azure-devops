from flask import Flask, jsonify, request
import logging
import os
import sys
from datetime import datetime

app = Flask(__name__)

# Configure logging to stdout
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
CONNECTION_STRING = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING", "")

# Initialize Application Insights if configured
APP_INSIGHTS_ENABLED = False
if CONNECTION_STRING or INSTRUMENTATION_KEY:
    try:
        from opencensus.ext.azure.log_exporter import AzureLogHandler
        from opencensus.ext.azure.trace_exporter import AzureExporter
        from opencensus.ext.flask.flask_middleware import FlaskMiddleware
        from opencensus.trace.samplers import ProbabilitySampler
        
        # Add Azure Log Handler for sending logs to Application Insights
        azure_handler = AzureLogHandler(connection_string=CONNECTION_STRING)
        logger.addHandler(azure_handler)
        
        # Add Flask Middleware for automatic request/response tracking
        middleware = FlaskMiddleware(
            app,
            exporter=AzureExporter(connection_string=CONNECTION_STRING),
            sampler=ProbabilitySampler(rate=1.0),
        )
        
        APP_INSIGHTS_ENABLED = True
        logger.info("✅ Application Insights enabled successfully")
    except ImportError:
        logger.warning("⚠️ Application Insights libraries not installed. Install opencensus-ext-azure and opencensus-ext-flask")
    except Exception as e:
        logger.error(f"❌ Failed to enable Application Insights: {e}")
else:
    logger.warning("⚠️ Application Insights not configured - missing connection string")

# Log application startup
logger.info("=" * 50)
logger.info("Starting DevOps Demo Application")
logger.info(f"Environment: {ENVIRONMENT}")
logger.info(f"Version: {APP_VERSION}")
logger.info(f"Application Insights: {'Enabled' if APP_INSIGHTS_ENABLED else 'Disabled'}")
logger.info("=" * 50)

@app.before_request
def log_request_info():
    """Log incoming request details"""
    logger.info(f"→ Request: {request.method} {request.path} from {request.remote_addr}")

@app.after_request
def log_response_info(response):
    """Log response details"""
    logger.info(f"← Response: {request.method} {request.path} - Status: {response.status_code}")
    return response

@app.get("/health")
def health():
    """Simple health check endpoint"""
    logger.info("Health check endpoint called")
    return jsonify({"status": "ok"}), 200

@app.get("/")
def home():
    """Home endpoint with application info"""
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
    """Detailed application information endpoint"""
    logger.info("Info endpoint accessed")
    return jsonify({
        "application": "DevOps Demo App",
        "environment": ENVIRONMENT,
        "version": APP_VERSION,
        "python_version": sys.version,
        "monitoring": {
            "application_insights": "enabled" if APP_INSIGHTS_ENABLED else "disabled",
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

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    logger.error(f"500 Internal Server Error: {str(error)}", exc_info=True)
    return jsonify({
        "error": "Internal Server Error",
        "message": "An unexpected error occurred",
        "status_code": 500
    }), 500

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
    logger.info("Starting Flask development server on 0.0.0.0:3000")
    app.run(host="0.0.0.0", port=3000, debug=False)
