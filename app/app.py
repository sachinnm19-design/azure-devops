from flask import Flask, jsonify
import logging
import sys

app = Flask(__name__)

logging.basicConfig(
    level=logging.INFO,
    handlers=[logging.StreamHandler(sys.stdout)]
)

@app.get("/health")
def health():
    logging.info("Health called")
    return jsonify({"status": "ok"}), 200

@app.get("/")
def home():
    return jsonify({"message": "Demo app running"}), 200
