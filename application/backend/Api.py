import json
from flask import Flask, jsonify, request

api = Flask(__name__)

result = 0

@api.route('/sum/<(int:x, int:y)>', methods=['GET'])
def result(x, y: int):
    result = x + y
    return jsonify(result)

if __name__ == '__main__':
   api.run(port=5000)