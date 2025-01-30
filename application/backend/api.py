import pika
import os
import redis
from flask import Flask, jsonify, request
from flask_cors import CORS # type: ignore

api = Flask(__name__)
CORS(api)

r = redis.Redis(host='redis', port=6379, decode_responses=True, db=0)

try:
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq'))
    channel = connection.channel()
    channel.queue_declare(queue='calculs_queue', durable=True)
except pika.exceptions.AMQPConnectionError as e:
    print(f"Error connecting to RabbitMQ: {e}")
    connection = None
    channel = None

results = {}

@api.route('/')
def home():
    return "API is running!"

@api.route('/api/calculate', methods=['POST'])
def calculate():
    data = request.get_json()
    expression = data.get('expression')
    calc_id = str(r.incr('calc_id')) 
    try:
        import json
        channel.basic_publish(exchange='',
                      routing_key='calculs_queue',
                      body=json.dumps({'expression': expression,
                                       'calc_id': calc_id}))
        print(" [x] Sent {body}")
        return jsonify({"id": calc_id, "calcul": expression}), 200
    except Exception as e:
        return jsonify({"error queuing the calc": str(e)}), 400

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
   
