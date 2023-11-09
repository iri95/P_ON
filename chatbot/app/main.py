from typing import Union
from fastapi import FastAPI, Header
from pydantic import BaseModel
from model.make_schedule import make_schedule
app = FastAPI()


# 일정 생성
@app.post("/chatbot")
async def create_calendar(userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id")):

    text = "11월 18일에 서면에서 3차팀 회식 있어."

    res = make_schedule(text)
    
    return {"res" : res}


# 일정 조회
@app.get("/chatbot")
async def root(userId: Union[int, None] = Header(default=None, convert_underscores=False, alias="id")):
    context = {
        "message": "안녕 쁘롱트",
        "userId": userId
    }
    return context