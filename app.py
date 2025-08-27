import os
import shlex
import subprocess
from flask import request
from flask import Flask, Response, jsonify
from generate_feed import generate_feed

app = Flask(__name__)


@app.route("/")
def home():
    return "Hello depuis Flask 🚀"


if __name__ == "__main__":
    app.run(debug=True)


@app.route("/feed", methods=["GET"])
def get_feed():
    data = generate_feed()
    return Response(data, mimetype="application/xml")


@app.route("/run-command", methods=["POST"])
def run_command():
    command = request.json.get("command")
    if not command:
        return jsonify({"error": "No command provided"}), 400

    try:
        args = shlex.split(command)
        result = subprocess.run(args, capture_output=True, text=True)
        return jsonify(
            {
                "stdout": result.stdout,
                "stderr": result.stderr,
                "returncode": result.returncode,
            }
        )
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))  # Tu peux changer le port ici
    app.run(debug=True, host="0.0.0.0", port=port)
