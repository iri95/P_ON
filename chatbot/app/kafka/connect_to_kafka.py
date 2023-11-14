import json
import os
import pandas as pd
from kafka3 import KafkaProducer, KafkaConsumer

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
        'from-mysql-json',
        group_id='chatbot-consumer',
        bootstrap_servers=['server2:9092'],
        value_deserializer=lambda x: json.loads(x.decode('utf-8')) 
    )

    for message in consumer:
        data = message.value
        userId = data['userId']
        cal = data['cal']
    
        file_path = f'../data/cal_{userId}.csv'
        user_df = pd.DataFrame({'userId': [userId]})
        cal_df = pd.DataFrame([cal])
        df = pd.concat([user_df, cal_df], axis=1)

        if file_path in os.listdir():
            existing_df = pd.read_csv(file_path) 
        else:
            existing_df = pd.DataFrame()
        
        combined_df = pd.concat([existing_df, df], ignore_index=True)
        combined_df.to_csv(file_path, index=False)
        
        return f'Save to {file_path}'


