
# import os
# import yaml

# from langchain.agents import (
#     create_json_agent,
#     AgentExecutor
# )
# from langchain.agents.agent_toolkits import JsonToolkit
# from langchain.chains import LLMChain
# from langchain.llms.openai import OpenAI
# from langchain.requests import TextRequestsWrapper
# from langchain.tools.json.tool import JsonSpec


# with open("../data/cal_1.yml") as f:
#     data = yaml.load(f, Loader=yaml.FullLoader)
# json_spec = JsonSpec(dict_=data, max_value_length=4000)
# json_toolkit = JsonToolkit(spec=json_spec)

# json_agent_executor = create_json_agent(
#     llm=OpenAI(temperature=0),
#     toolkit=json_toolkit,
#     verbose=True
# )

# usr = json_agent_executor.run("이번 주 토요일 일정이 뭐야?")
# print(f'답변 :{usr}')