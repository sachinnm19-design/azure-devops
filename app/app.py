from flask import Flask, jsonify
import logging
import os
from azure.monitor.opentelemetry import configure_azure_monitor

# Enable Azure Application Insights
configure_azure_monitor()

app = Flask(__name__)

# Basic logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route("/health")
def health():
    logger.info("Health endpoint called")
    return jsonify({"status": "ok"}), 200

@app.route("/")
def home():
    logger.info("Home endpoint called")
    return "Hello from Azure Web App for Containers!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
