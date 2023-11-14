from langchain.llms import OpenAI
from langchain.chat_models import ChatOpenAI
from langchain.agents.agent_types import AgentType

from langchain_experimental.agents.agent_toolkits import create_csv_agent

agent = create_csv_agent(
    ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613"),
    "../data/cal_1.csv",
    verbose=True,
    agent_type=AgentType.OPENAI_FUNCTIONS,
)

res = agent.run("이번 주 토요일 일정 알려줘")
print(res)