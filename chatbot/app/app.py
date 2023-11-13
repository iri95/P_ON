from flask import Flask
from model.make_schedule import UserMessage_to_cal

app = Flask(__name__)


@app.route('/chat', methods=['POST'])
def chat():
    text = "이번 주 토요일에 하단에서 2차 회식이야."
    print(text)
    res = UserMessage_to_cal(text)
    context = {
        'userMessage' : text,
        'answer' : res
    }
    print(context)
    topic_message = {
        'userId' : 1,
        'cal' : res
    }

    # kakfa_res = kafka_producer(topic_message)

    return {"res" : context}