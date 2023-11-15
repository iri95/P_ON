from langchain.chat_models import ChatOpenAI
from langchain.chains import create_extraction_chain
from langchain.schema import HumanMessage
from pymongo import MongoClient
import os


def to_datetime(inp):

    chat = ChatOpenAI()
    output = chat(
            [
                HumanMessage(
                    content=f"""Convert the phrase "{inp}" to a date in YYYY-MM-DD format, considering today as the reference.
                    If today's date is 2023-11-14,
                        
                    Input: 오늘 
                    Output: 2023-11-14
                    
                    Input: 이번 주 일요일  
                    Output: 2023-11-19
                    
                    Input: 다움 주 월요일  
                    Output: 2023-11-20
                    
                    Input: 이번 주 
                    Output:2023-11-14, 2023-11-15, 2023-11-16, 2023-11-17, 2023-11-18, 2023-11-19, 2023-11-20
                    
                    Input: 다음 주 
                    Output:2023-11-20, 2023-11-21, 2023-11-22, 2023-11-23, 2023-11-24, 2023-11-25, 2023-11-26
                    
                    Input: {inp}
                    Output:"""
                )
            ]
    )
    
    return output.content



def UserMessage_to_cal(userMessage):
    
    schema = {
    "properties": {
        "calendar_title": {"type": "string"},
        "calendar_place": {"type": "string"},
        "calendar_start_date": {"type": "string"},
        "calendar_end_date": {"type": "string"}
    },
    "required": ["user_id", "calendar_title", "calendar_start_date"],
    }
    
    llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo")
    chain = create_extraction_chain(schema, llm)
    res = chain.run(userMessage)

    if res != []:
        res = res[0]
        
        if res['calendar_start_date']:
            res['calendar_start_date'] = to_datetime(res['calendar_start_date'])
        
        if 'calendar_end_date' not in res:
            res['calendar_end_date'] = res.get('calendar_start_date')
        else:
            res['calendar_end_date'] = to_datetime(res['calendar_end_date'])
    else:
        res = None
        
    return res


mongo_password = os.environ.get('MONGO_AUTH')
def find_from_mongo(userId, userMessage):
    client = MongoClient(f'mongodb://root:{mongo_password}@server2:27017/')
    db = client.chatbot 
    collection = db.test

    date_res = to_datetime(userMessage)
    date_res = date_res.split(', ')
    
    query = {
        'userId': userId,
        'cal.calendar_start_date': {'$in': date_res}
    }
    result_cursor = collection.find(query)

    res = []
    for doc in result_cursor:
        res_doc = {
            'userId': doc['userId'],
            'cal': doc['cal']
        }
        res.append(res_doc)
        
    return res

