from flask import Flask, request, jsonify
import subprocess
import shlex

app = Flask(__name__)

@app.route('/')
def home():
    return '🐦 Blackbird est en vol !'

@app.route('/run', methods=['POST'])
def run_command():
    data = request.get_json()
    if not data or 'cmd' not in data:
        return jsonify({'error': 'Commande manquante'}), 400

    cmd = data['cmd']

    # Sécurisation de la commande
    if not isinstance(cmd, str) or not cmd.strip():
        return jsonify({'error': 'Commande invalide'}), 400

    try:
        # Utilisation de shlex.split pour éviter les injections shell
        result = subprocess.check_output(shlex.split(cmd), stderr=subprocess.STDOUT, text=True)
        return jsonify({'output': result})
    except subprocess.CalledProcessError as e:
        return jsonify({'error': e.output}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)

