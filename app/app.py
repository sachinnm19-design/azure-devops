from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/health")
def health():
    return jsonify(STATUS="OK")

@app.get("/")
def home():
    return "DevOps Demo App is running!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
