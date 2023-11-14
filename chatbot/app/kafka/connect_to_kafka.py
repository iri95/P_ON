import json
import os
import csv
import pandas as pd
from kafka3 import KafkaProducer, KafkaConsumer, TopicPartition

def kafka_producer(message):
    producer = KafkaProducer(
        bootstrap_servers="server2:9092",
        value_serializer=lambda v: json.dumps(v).encode('utf-8')  # JSON 직렬화 설정
    )

    response = producer.send(topic='from-chatbot-json', value=message).get()
    producer.flush()
    return response



def kafka_consumer():
    consumer = KafkaConsumer(
        'test-topic',
        group_id='chatbot-test',
        bootstrap_servers=['server2:9092'],
        value_deserializer=lambda x: json.loads(x.decode('utf-8')) 
    )

    for message in consumer:
        data = message.value
        userId = data['userId']
        print(userId)

        file_path = f'../data/cal_{userId}.json'

        try:
            with open(file_path, 'a') as jsonfile:
                jsonfile.write(json.dumps(data) + '\n')
            print(f"Received message: {message.value}")

        except FileNotFoundError:
            with open(file_path, 'w') as jsonfile:
                jsonfile.write(json.dumps(data) + '\n')
            print(f"Received message: {message.value}")



kafka_consumer()

