from flask import Flask, jsonify
import logging
import os
from azure.monitor.opentelemetry import configure_azure_monitor

# Create Flask app
app = Flask(__name__)

# Configure Azure Monitor (Application Insights)
# Requires APPLICATIONINSIGHTS_CONNECTION_STRING env variable
configure_azure_monitor()

# Configure standard logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/health')
def health():
    logger.info("Health endpoint called")
    return jsonify({"status": "ok"}), 200

@app.route('/')
def index():
    logger.info("Home endpoint accessed")
    return jsonify({"message": "Hello from App Insights!"}), 200

@app.route('/error')
def error():
    # This will automatically appear in App Insights exceptions table
    raise Exception("Test exception for monitoring")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
