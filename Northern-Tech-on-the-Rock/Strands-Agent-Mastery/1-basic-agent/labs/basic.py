from strands import Agent
from strands_tools import calculator, current_time, python_repl

agent = Agent(tools=[calculator, current_time, python_repl])
response = agent("What is the square root of 80 / 4 * 5?") # prompt
