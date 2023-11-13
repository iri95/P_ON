
from kafka.connect_to_kafka import kafka_producer
from typing import Union
from fastapi import FastAPI, Header
from model.make_schedule import UserMessage_to_cal


app = FastAPI()


# 일정 생성
from fastapi import FastAPI, Header, Body
from typing import Union

app = FastAPI()

# 일정 생성
@app.post("/chatbot")
async def create_calendar(
    userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id"),
    text: str = Body(...)
):

    res = UserMessage_to_cal(text)
    topic_message = {
        'userId' : userId,
        'cal' : res
    }

    kafka_producer(topic_message)

    return {"res" : topic_message}


# 일정 조회
@app.get("/chatbot")
async def root(userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id")):
    context = {
        "message": "안녕 쁘롱트",
        "userId": userId
    }
    return context