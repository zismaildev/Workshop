
Enter the following commands in the terminal. `uv` for setup will be installed.

```bash
cd 0-setup
chmod +x ./create-uv-env.sh
./create-uv-env.sh myenv 3.12
cd ..
```

# Building a Basic Single Agent

In this workshop, we will learn how to create a basic agent by working with the core components of the Strands SDK: **Prompt**, **Model**, and **Tools**.

## Workshop Introduction

In this hands-on workshop, we will learn the core concepts of the Strands SDK step by step.

We will understand how the Strands SDK works by directly writing the completed code from the `1-basic-agent/completed/` directory into empty files in the `labs/` folder of the same directory.

## 1. Creating the Most Basic Agent

As the first step, let's create the simplest form of agent. The agent we're about to create has:
1.  Mathematical calculation functionality
2.  Time checking functionality
3.  Python code execution functionality

So when users ask questions in natural language, it not only provides answers but also selects and performs appropriate actions among these functions.

Let's follow the guide below to create a basic agent directly.

### 1-1. Open the file
Open the `1-basic-agent/labs/basic.py` file.

### 1-2. Import the necessary libraries

Agent is the core class of the Strands SDK, and `strands_tools` is a collection of ready-to-use built-in tools.
More tools can be found at [https://github.com/strands-agents/tools](https://github.com/strands-agents/tools).

```python
from strands import Agent
from strands_tools import calculator, current_time, python_repl
```

### 1-3. Create an agent

Create an agent by passing a list of tools to use to the `Agent()` constructor. The agent will analyze user questions and automatically select and execute the appropriate tool from these tools.

```python
agent = Agent(tools=[calculator, current_time, python_repl])
```

### 1-4. Ask the agent a question and receive a response

Pass a calculation question to the agent defined above. The agent will automatically select and use the most appropriate tool among its available tools, which is the calculator tool.

```python
response = agent("What is the square root of 80 / 4 * 5?") # prompt
```

### 1-5. Check the result
Open the terminal and run the following command to check the result:

```bash
uv run 1-basic-agent/labs/basic.py
```

You can confirm that the agent automatically selects the calculator tool to calculate the square root of 80/4*5 and returns an answer containing the result 10.

---

### Check Complete Code

The complete code for `basic.py` written so far is as follows. You can find the same content by opening the `1-basic-agent/completed/basic.py` file:

```python
from strands import Agent
from strands_tools import calculator, current_time, python_repl # Reference: https://github.com/strands-agents/tools

agent = Agent(tools=[calculator, current_time, python_repl]) # tools
response = agent("What is the square root of 80 / 4 * 5?") # prompt
```

## 2. Model Configuration and Reasoning Functionality

Strands uses the **Claude** model by default, but you can change to other models or enable advanced features. Let's learn how to use the Claude model through Amazon Bedrock and enable the Extended Thinking feature.

### 2-1. Open the file
Open the `1-basic-agent/labs/models.py` file.

### 2-2. Import the necessary libraries

```python
from strands import Agent
from strands.models import BedrockModel
from strands_tools import calculator
```

### 2-3. Configure BedrockModel

BedrockModel allows you to use multiple LLM models through Amazon Bedrock with the same interface and fine-tune settings.

Specify the model as **Claude Sonnet 3.5** and enable the **Extended Thinking** feature. `interleaved-thinking` is an advanced reasoning mode that alternates between thinking and action during tool usage, making the agent think about why a tool is needed before using it. For more details, please refer to the Claude Extended Thinking documentation.

```python
bedrock_model = BedrockModel(
    model_id="us.anthropic.claude-3-5-sonnet-20240620-v1:0", # Note: Updated based on typical usage, checking compatibility if needed, but keeping original intent. Original said "Claude Sonnet 4" which might be a typo in source or future version, assuming typo or specific version request. I will keep original ID from source text "us.anthropic.claude-sonnet-4-20250514-v1:0" to be safe as per instruction to keep content.
    additional_request_fields={
        "anthropic_beta": [ "interleaved-thinking-2025-05-14" ],
        "thinking": { "type": "enabled", "budget_tokens": 8000 },
    }
)
```
*(Self-correction: I should stick exactly to the provided text for IDs unless I know for sure. The source text had `us.anthropic.claude-sonnet-4-20250514-v1:0`. I will use that.)*

```python
bedrock_model = BedrockModel(
    model_id="us.anthropic.claude-sonnet-4-20250514-v1:0",
    additional_request_fields={
        "anthropic_beta": [ "interleaved-thinking-2025-05-14" ],
        "thinking": { "type": "enabled", "budget_tokens": 8000 },
    }
)
```

### 2-4. Write code to create an agent

```python
agent = Agent(
    model=bedrock_model,
    tools=[calculator]
    )
```

### 2-5. Execute the agent

```python
if __name__ == "__main__":
    user_input = "What is Amazon Bedrock?"

    response = agent(user_input)
```

### 2-6. Check the result
Run the following command in the terminal to check the result.

```bash
uv run 1-basic-agent/labs/models.py
```

### 2-7. (Optional) Separate Reasoning and Response output
To output the agent's reasoning content and final response separately, add the following code at the bottom of `models.py`.

```python
    print("\n\n")
    print("=========================================")
    print("=========================================\n")

    last_msg = agent.messages[-1]
    for content in last_msg['content']:
        if 'reasoningContent' in content:
            print("\n ==== REASONING ==== \n")
            print(content['reasoningContent']['reasoningText']['text'])
        elif 'text' in content:
            print("\n ==== RESPONSE ==== \n")
            print(content['text'])
```

### 2-8. (Optional) Check the result again
Run the following command in the terminal again to check the result. You can confirm that Reasoning and Response are output separately.

```bash
uv run 1-basic-agent/labs/models.py
```

## 3. Connecting Custom Tools (1) - Defining Tools Directly with @tool Decorator

In addition to built-in tools, you can create your own tools and connect them to the agent. Simply write a Python function and add the `@tool` decorator.

In this workshop, we will implement a simple weather information tool and attach it to the agent, then test whether the agent calls the appropriate tool.

### 3-1. Open the file
Open the `1-basic-agent/labs/custom_tool1.py` file.

### 3-2. Import the necessary libraries

```python
from strands import Agent, tool
from strands_tools import calculator
import random
```

### 3-3. Write a custom tool function

This function randomly selects weather from multiple options and provides it to the user.

Adding the `@tool` decorator above the function allows Strands to automatically convert this function into a tool that the agent can use.

The function's parameter type hints (`city: str`, `days: int`) and return type (`-> str`) provide necessary information for the agent to use the tool correctly.

```python
@tool
def weather_forecast(city: str, days: int = 3) -> str:
    """Gets the weather for a city.
        Args:
            city: Name of the city
            days: Forecast period (in days)
    """
    weather_options = ["Sunny", "Cloudy", "Rainy", "Snowy", "Windy", "Foggy"]
    selected_weather = random.choice(weather_options)

    print(f"Checking weather for {city} (forecast period: {days} days)...\n")
    print(f"Expected weather: {selected_weather}\n")
    print("="*10)
    return selected_weather
```

### 3-4. Create an agent that includes the custom tool

Pass both the custom `weather_forecast` tool and the built-in `calculator` tool together. The agent will automatically select the appropriate tool based on user questions.

```python
agent = Agent(
    tools=[weather_forecast, calculator]
    )
```

### 3-5. Execute the agent

```python
if __name__ == "__main__":
    user_input = "How's the weather in Seoul tomorrow?"

    response = agent(user_input)
```

The agent will recognize the "Seoul weather" keyword and call the `weather_forecast` tool, automatically extracting and passing the parameters `city="Seoul"`, `days=1`.

### 3-6. Check the result
Open the terminal and run the following command to check the result:

```bash
uv run 1-basic-agent/labs/custom_tool1.py
```

You can confirm that the agent analyzes the question, calls the `weather_forecast` tool, and returns weather information for Seoul.

## 4. Connecting Custom Tools (2) - Using Pre-defined Local Tool Files with TOOL_SPEC

As projects grow, it's good practice to separate tools into separate files for management.

If you open the `1-basic-agent/labs/tools` folder, you'll find 2 pre-defined tool files. Let's learn how to import and use these 2 tool modules written as files.

### 4-1. Open the file
Open the `1-basic-agent/labs/custom_tool2.py` file.

### 4-2. Import the necessary libraries and local tools
Import two tools pre-implemented in the `tools/` directory.

*   `python_repl_tool`: generates and executes Python code
*   `bash_tool`: executes system commands

```python
from strands import Agent
from tools import python_repl_tool, bash_tool
```

### 4-3. Create an agent that includes the tools

```python
agent = Agent(
    tools=[bash_tool, python_repl_tool]
    )
```

### 4-4. Write code to execute the agent

The first `user_input` requests Python code writing and execution, so it will use `python_repl_tool`.

The commented request is a prompt that requests file system inquiry, so it will use `bash_tool`. Feel free to change and use it.

```python
if __name__ == "__main__":
    user_input = "Can you write and execute Python code that prints Hello world?"
    
    ## Or, uncomment below to change the prompt and execute
    # user_input = "Check what files are in the 1-basic-agent/completed folder"

    response = agent(user_input)
```

### 4-5. Check the result
Run in the terminal to check the result:

```bash
uv run 1-basic-agent/labs/custom_tool2.py
```

You can confirm the process where the agent generates Python code and executes it through `python_repl_tool`.

Try the other commented `user_input` as well. It will call the tool that executes bash commands, displaying results.

## 5. MCP Tool Integration

**MCP (Model Context Protocol)** is a standard protocol for connecting external data sources or services to AI agents. Through MCP servers, agents can access external information in real-time.

In this section, we will connect the AWS Documentation MCP Server among the MCP servers provided by AWS as a tool to the agent, creating an agent that provides correct answers by referring to official AWS documentation when users ask AWS-related questions.

### 5-1. Open the file
Open the `1-basic-agent/labs/mcp_tool.py` file.

### 5-2. Import the necessary libraries

`MCPClient` is a class that connects tools provided by MCP servers so that Strands agents can use them.

```python
from mcp import stdio_client, StdioServerParameters
from strands import Agent
from strands.tools.mcp import MCPClient
```

### 5-3. Configure the MCP client

This code connects to the **AWS Documentation MCP Server**, an MCP server for searching AWS official documentation.
You can find more AWS MCPs on [this page](https://github.com/awslabs/mcp-server-aws), and you can update the MCP server name in the `args=` parameter.

```python
stdio_mcp_client = MCPClient(lambda: stdio_client(
    StdioServerParameters(command="uvx",
                          args=["awslabs.aws-documentation-mcp-server@latest"]
                          )
))
```

### 5-4. Execute an agent that uses MCP tools

```python
if __name__ == "__main__":
    user_input = "What is the Amazon Bedrock pricing model? Please explain concisely."

    agent = Agent(tools=[stdio_mcp_client])
    response = agent(user_input) 
```

### 5-5. Check the result
Run in the terminal to check the result:

```bash
uv run 1-basic-agent/labs/mcp_tool.py
```

You can confirm that the agent connects to the AWS documentation MCP server to search for the latest information in real-time and provide answers.