import json
from flask import Flask, jsonify, request

api = Flask(__name__)

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
        calc_id = str(len(results) + 1)
        results[calc_id] = result
        return jsonify({"id": calc_id, "result": result})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# Requête test POST calcul : curl -X POST http://localhost:5000/api/calculate -H "Content-Type: application/json" -d "{\"expression\": \"2+2\"}"


@api.route('/api/sum/<id>', methods=['GET'])
def result(id):
    result = results.get(id)
    
    if not result:
        return jsonify({'error': 'Result not found'}), 404
    
    return jsonify(result), 200

# Requête test GET résultat : curl -X GET http://localhost:5000/api/sum/<id> --> s'assurer d'avoir fait une requête post pour un calcul avant et remplacer l'<id>

if __name__ == '__main__':
   api.run(debug=True, host='0.0.0.0', port=5000)
   
