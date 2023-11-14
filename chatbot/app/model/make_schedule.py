from langchain.chat_models import ChatOpenAI
from langchain.chains import create_extraction_chain
from langchain.schema import HumanMessage

def to_datetime(inp):
    
    chat = ChatOpenAI()
    output = chat(
            [
                HumanMessage(
                    content=f"""
                        Convert the phrase "{inp}" to a date in YYYY-MM-DD format.
                        
                        Input: 이번 주 일요일  
                        Output: 2023-11-12
                        
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
        res = {}
        
    return res