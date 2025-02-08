from flask import json
import pika
import time, jsonify, redis, sys
import os


def connect_to_rabbitmq():
    while True:
        try:
            connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq-service', heartbeat=30))
            print("Connected to RabbitMQ!")
            return connection
        except pika.exceptions.AMQPConnectionError:
            print("Waiting for RabbitMQ to be ready...")
            time.sleep(4)


def make_calc(expression, calc_id):
        r = redis.Redis(host='redis-service', port=6379, decode_responses=True, db=0)
        
        result = eval(expression)
        
        r.set(calc_id, result)

def calc():
    # amqp_url = os.environ['AMQP_URL']
    # url_params = pika.URLParameters(amqp_url)
    
    connection = connect_to_rabbitmq()
    channel = connection.channel()
    
    channel.queue_declare(queue='calculs_queue', durable=True)
    
    def callback(ch, method, properties, body):
        print(f" [x] Received {body}")
        try: 
            data = json.loads(body)
            make_calc(data['expression'], data['calc_id'])
        except Exception as e:
            print(f"Error while calculating: {e}")
        time.sleep(5)
        ch.basic_ack(delivery_tag=method.delivery_tag)
    
    channel.basic_qos(prefetch_count=1)
    channel.basic_consume(queue='calculs_queue', on_message_callback=callback)
    
    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()
    
if __name__ == '__main__':
    try:
        calc()
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)