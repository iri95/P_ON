from langchain.chat_models import ChatOpenAI
from langchain.chains import create_extraction_chain
from langchain.schema import HumanMessage
from make_schedule import to_datetime
from pprint import pprint

from langchain.document_loaders import JSONLoader

def find_cal(userId):
    loader = JSONLoader(
        file_path=f'../data/cal_{userId}.json',
        jq_schema='.messages[].content',
        text_content=False)

    data = loader.load()
    pprint(data)

find_cal(1)