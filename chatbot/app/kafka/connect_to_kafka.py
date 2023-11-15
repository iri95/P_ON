import json
from kafka3 import KafkaProducer

def kafka_producer(message):
    producer = KafkaProducer(
        bootstrap_servers="server2:9092",
        value_serializer=lambda v: json.dumps(v).encode('utf-8')  
    )

    response = producer.send(topic='from-chatbot-json', value=message).get()
    producer.flush()
    return response