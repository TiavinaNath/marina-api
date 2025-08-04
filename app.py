from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/api/sat', methods=['POST'])
def solve():
    data = request.get_json()
    prop = data.get('prop')
    if not prop:
        return jsonify({'error': 'Missing proposition'}), 400

    try:
        result = subprocess.check_output(["./marina", prop], stderr=subprocess.STDOUT)
        return jsonify({'result': result.decode().strip()})
    except subprocess.CalledProcessError as e:
        return jsonify({'error': e.output.decode()}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
