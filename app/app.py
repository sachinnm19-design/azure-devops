from flask import Flask, jsonify
import logging

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

@app.get("/health")
def health():
    app.logger.info("Health endpoint called")
    return jsonify({"status": "ok"}), 200
