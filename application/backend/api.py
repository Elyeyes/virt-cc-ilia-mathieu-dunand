import json
import redis
from flask import Flask, jsonify, request
from flask_cors import CORS # type: ignore

api = Flask(__name__)
CORS(api)

r = redis.Redis(host='localhost', port=6379, decode_responses=True, db=0)

results = {}

@api.route('/')
def home():
    return "API is running!"

@api.route('/api/calculate', methods=['POST'])
def calculate():
    data = request.get_json()
    expression = data.get('expression')
    try:
        result = eval(expression)
        calc_id = str(r.incr('calc_id')) 
        r.set(calc_id, result)
        return jsonify({"id": calc_id, "result": result})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# Requête test POST calcul : curl -X POST http://localhost:5000/api/calculate -H "Content-Type: application/json" -d "{\"expression\": \"2+2\"}"


@api.route('/api/result/<id>', methods=['GET'])
def result(id):
    result = r.get(id)
    
    if not result:
        return jsonify({'error': 'Result not found'}), 404
    
    return jsonify(result), 200

# Requête test GET résultat : curl -X GET http://localhost:5000/api/result/<id> --> s'assurer d'avoir fait une requête post pour un calcul avant et remplacer l'<id>

if __name__ == '__main__':
   api.run(debug=True, host='0.0.0.0', port=5000)
   
