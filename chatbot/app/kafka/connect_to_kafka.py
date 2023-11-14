
import json
from kafka3 import KafkaProducer, KafkaConsumer


def kafka_producer(message):
    producer = KafkaProducer(
        bootstrap_servers="server2:9092",
        value_serializer=lambda v: json.dumps(v).encode('utf-8')  # JSON 직렬화 설정
    )

    response = producer.send(topic='to-mysql-json', value=message).get()
    producer.flush()
    return response

def kafka_consumer_skip_messages():
    # Kafka 소비자 설정
    consumer = KafkaConsumer(
        'from-mysql-json',
        group_id='chatbot-service',
        bootstrap_servers=['server2:9092'],
        value_deserializer=lambda x: json.loads(x.decode('utf-8'))  # JSON 역직렬화 설정
    )


    # 메시지 소비
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


# Kafka 소비자 함수 호출
kafka_consumer_skip_messages()


