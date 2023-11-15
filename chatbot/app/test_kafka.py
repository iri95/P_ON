# from pydantic import BaseModel
# from fast_kafka_api.application import FastKafkaAPI

# from fastapi import FastAPI, Header, Request

# class InputData(BaseModel):
#     userId: int
#     calendar_title: str
#     calendar_place: str
#     calendar_start_date: str
#     calendar_end_date: str

# # from os import environ


# kafka_server_url = 'server2'
# kafka_server_port = 9092

# kafka_brokers = {
#     "production": {
#         "url": kafka_server_url,
#         "description": "production kafka broker",
#         "port": 9092,
#     },
# }

# kafka_config = {
#     "bootstrap_servers": f"{kafka_server_url}:{kafka_server_port}",
# }

# app = FastKafkaAPI(
#     title="FastKafkaAPI Example",
#     version="0.0.1",
#     description="A simple example on how to use FastKafkaAPI",
#     kafka_brokers=kafka_brokers,
#     **kafka_config,
# )



# @app.consumes(topic="from-mysql-json")
# async def on_input_data(msg: InputData):
#     print(f"msg={msg}")
    