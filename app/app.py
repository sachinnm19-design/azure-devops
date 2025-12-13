from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


@app.route("/")
def home():
    return "Hello from Azure Web App for Containers via GitHub Actions & Terraform!"


if __name__ == "__main__":
    # Runs on port 3000 and listens on all interfaces
    app.run(host="0.0.0.0", port=3000)
