from typing import Union
from fastapi import FastAPI, Header
from pydantic import BaseModel

app = FastAPI()


# 일정 생성
@app.post("/chatbot")
async def create_calendar(userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id")):
    context = {
        "message": "안녕 쁘롱트",
        "userId": userId
    }
    return context


# 일정 조회
@app.get("/chatbot")
async def root(userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id")):
    context = {
        "message": "안녕 쁘롱트",
        "userId": userId
    }
    return context