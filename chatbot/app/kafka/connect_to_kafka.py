# import json
# from kafka3 import KafkaProducer, TopicPartition
# from kafka3 import KafkaConsumer

# def kafka_producer(message):
#     producer = KafkaProducer(
#         bootstrap_servers="server2:9092",
#         value_serializer=lambda v: json.dumps(v).encode('utf-8')  # JSON 직렬화 설정
#     )

#     response = producer.send(topic='test-topic', value=message).get()
#     producer.flush()
#     return response

# def kafka_consumer_skip_messages():
#     # Kafka 소비자 설정
#     consumer = KafkaConsumer(
#         # 'test-topic',
#         group_id='my-group',
#         bootstrap_servers=['server2:9092'],
#         value_deserializer=lambda x: json.loads(x.decode('utf-8'))  # JSON 역직렬화 설정
#     )

#     # 특정 파티션과 오프셋 지정
#     partition = 0  # 파티션 번호
#     offset_to_skip = 18  # 시작 오프셋 - 1

#     # TopicPartition 객체를 사용하여 파티션과 오프셋 지정
#     topic_partition = TopicPartition('test-topic', partition)
#     consumer.assign([topic_partition])

#     # 특정 오프셋으로 이동
#     consumer.seek(topic_partition, offset_to_skip + 1)  # 지정된 오프셋 이후부터 읽기

#     # 메시지 소비
#     for message in consumer:
#         data = message.value
#         print(f"수신한 메시지: {data}")
#          # Append the data to a JSON file
#         with open('../data/cal.json', 'a') as jsonfile:
#             # Write each message as a new line in the JSON file
#             jsonfile.write(json.dumps(data) + '\n')

#         print(f"Received message: {message.value}")


# # Kafka 소비자 함수 호출
# kafka_consumer_skip_messages()


