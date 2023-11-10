from langchain.chat_models import ChatOpenAI
from langchain.chains import create_extraction_chain
from datetime import datetime
# Schema
schema = {
    "properties": {
        "calendar_title": {"type": "string"},
        "calendar_place": {"type": "string"},
        "calendar_start_date": {"type": "string"},
        "calendar_end_date": {"type": "string"}
    },
    "required": ["user_id", "calendar_title", "calendar_start_date"],
}

# Input
inp = """"에 서면에서 3차 회식이야."""

# Run chain
llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo")
chain = create_extraction_chain(schema, llm)
res = chain.run(inp)

