from kafka.connect_to_kafka import kafka_producer, kafka_consumer
from model.modules import UserMessage_to_cal
from model.modules import find_from_csv

from fastapi import FastAPI, Header, Request, BackgroundTasks
from typing import Union


app = FastAPI()



@app.on_event("startup")
async def execute_background_task(background_tasks: BackgroundTasks):
    res = "테스트"
    # background_tasks.add_task(some_background_task)
    # res = kafka_consumer()
    print(res)

@app.post("/chatbot")
async def create_calendar(
    request: Request,
    userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id"),
):
    json_data = await request.json()
    text = json_data.get("content", "")

    res = UserMessage_to_cal(text)

    topic_message = {
        'userId' : userId,
        'cal' : res
    }
    kafka_producer(topic_message)

    return {"res" : topic_message}


# 일정 조회
@app.get("/chatbot")
async def root(
    request: Request,
    userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id"),
    ):

    json_data = await request.json()
    text = json_data.get("content", "")

    res = find_from_csv(userId, text)
    return {"res" : res}


# 테스트 API
@app.get("/chatbot/connect-test")
async def root(userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id")):
    context = {
        'userId' : userId,
        'message' : 'hi'
    }
    return context