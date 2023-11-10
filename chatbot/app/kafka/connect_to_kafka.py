from kafka3 import KafkaProducer
producer = KafkaProducer(bootstrap_servers='server2:9092')

# producer = KafkaProducer(bootstrap_servers=["server2:9092","server2:9093","server1:9092"])
data = "python"
producer.send(topic='test-topic', value=data.encode('utf-8'))
producer.flush() # 