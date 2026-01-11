# 2. Building Systems that Perform Complex Tasks through Multi-Agent Patterns

In this workshop, we will learn how to build systems where multiple agents collaborate using multi-agent patterns from the Strands SDK.

We will practice the following 3 multi-agent patterns and create agent systems that solve complex tasks.

## Workshop Introduction

We will learn how multiple specialized agents can collaborate to solve more complex scenarios that are difficult for a single agent to handle.

We will understand the multi-agent patterns of the Strands SDK by directly writing the completed code from the `2-multi-agents/completed/` directory into empty files in the `labs/` folder of the same directory.

## 1. Agents-as-Tools Pattern

The **Agents-as-Tools pattern** is a method of wrapping specialized agents as tools so that other agents can call them as needed.

### Workshop Scenario

What if users make complex requests that mix multiple specialized domains, such as *"Research Spain, plan a family trip, and save the results to a file"*?

A single agent might be overloaded trying to handle all these requests. In such cases, by having each agent specialize in their own field, such as travel planning agents and research agents, and placing an **Orchestrator** agent that uses them as tools in the middle, each agent can focus only on their specialized area and handle requests more accurately and efficiently.

In this workshop, we will use the Agents-as-Tools pattern to create a multi-agent system that automatically classifies requests from various specialized domains such as research, product recommendations, and travel planning, and delegates them to appropriate specialized agents.

### 1-1. Open the file
Open the `2-multi-agents/labs/agents_as_tools.py` file.

### 1-2. Import the necessary libraries

```python
import os
from strands import Agent, tool
from strands_tools import file_write

# Disable file_write confirmation prompt
os.environ['BYPASS_TOOL_CONSENT'] = 'true' 
```

### 1-3. Wrap the research agent (research_assistant) with @tool

Create a tool from an agent specialized in research-related questions. This agent is dedicated to investigating information about countries, topics, etc.

Inside the function wrapped with the `@tool` decorator, we create and call a specialized agent. This makes the agent behave like a single tool.

```python
@tool
def research_assistant(query: str) -> str:
    """
    Processes and responds to research-related queries.

    Args:
        query: Research question requiring factual information

    Returns:
        Detailed research answer with citations
    """
    try:
        research_agent = Agent(
            system_prompt="""You are a professional research assistant.
            Focus on providing only factual information with clear sources for research questions.
            Always cite sources whenever possible.""",
        )
        response = research_agent(query)
        return str(response)
    except Exception as e:
        return f"Error in research assistant: {str(e)}"
```

### 1-4. Add the product recommendation agent (product_recommendation_assistant) as a tool

This is a specialized agent that provides personalized product suggestions based on user preferences.

```python
@tool
def product_recommendation_assistant(query: str) -> str:
    """
    Handles product recommendation queries by suggesting appropriate products.

    Args:
        query: Product inquiry including user preferences

    Returns:
        Personalized product recommendations with reasoning
    """
    try:
        product_agent = Agent(
            model="us.anthropic.claude-3-7-sonnet-20250219-v1:0",
            system_prompt="""You are a professional product recommendation assistant.
            Provide personalized product suggestions based on user preferences. Always cite sources.""",
        )
        response = product_agent(query)
        return str(response)
    except Exception as e:
        return f"Error in product recommendation: {str(e)}"
```

### 1-5. Add the trip planning agent (trip_planning_assistant) as a tool

This is a specialized agent that plans destinations and travel itineraries and provides travel advice.

```python
@tool
def trip_planning_assistant(query: str) -> str:
    """
    Creates travel itineraries and provides travel advice.

    Args:
        query: Travel planning request including destination and preferences

    Returns:
        Detailed travel itinerary or travel advice
    """
    try:
        travel_agent = Agent(
            model="us.anthropic.claude-3-7-sonnet-20250219-v1:0",
            system_prompt="""You are a professional travel planning assistant.
            Create detailed travel itineraries based on user preferences.""",
        )
        response = travel_agent(query)
        return str(response)
    except Exception as e:
        return f"Error in trip planning: {str(e)}"
```

### 1-6. Create and execute the orchestrator agent

The orchestrator analyzes user requests and selects and calls the appropriate specialized agent (tool).

```python
if __name__ == "__main__":

    MAIN_SYSTEM_PROMPT = """
    You are an assistant that routes queries to specialized agents:
    - For research questions and factual information → use the research_assistant tool
    - For product recommendations and shopping advice → use the product_recommendation_assistant tool
    - For travel planning and itineraries → use the trip_planning_assistant tool
    - For simple questions that don't require specialized knowledge → answer directly

    Always select the most appropriate tool based on the user's query.
    """

    orchestrator = Agent(
        system_prompt=MAIN_SYSTEM_PROMPT,
        tools=[
            research_assistant,
            product_recommendation_assistant,
            trip_planning_assistant,
            file_write,
        ],
    )

    os.environ["DEV"] = "true"
    customer_query = "Can you research Spain for me? And I'm planning to travel there with my parents for 7 days, can you help me plan it? Please save the plan you create to a plan.md file."

    response = orchestrator(customer_query)
```

### 1-7. Check the results
Run the following command in the terminal to check the results:

```bash
uv run 2-multi-agents/labs/agents_as_tools.py
```

### 📤 Understanding the Agents-as-Tools Pattern

The core of the Agents-as-Tools pattern is **wrapping agents as tools**.

The `research_assistant`, `product_recommendation_assistant`, and `trip_planning_assistant` that we just defined as Tools each have specialized agents inside them. These agents:

1.  When they receive specific requests from the orchestrator
2.  Autonomously determine methods like agents
3.  Use their own tools when necessary to perform tasks

#### Hierarchical Structure Visualization

```
                        Orchestrator (Top-level - Router)
                                   |
        ┌──────────────────────────┼────────────────────────────┬──────────────┐
        ↓                          ↓                            ↓              ↓
   research_assistant    product_recommendation    trip_planning_assistant   file_write
   (Agent and Tool)         (Agent and Tool)           (Agent and Tool)          (Built-in Tool)     
```

This way, the Strands SDK makes it easy to implement hierarchical multi-agent systems by wrapping agents as tools.

For more details, refer to the [official documentation](https://docs.strands.ai).

## 2. Swarm Pattern

The **Swarm pattern** is a method where multiple specialized agents autonomously collaborate and handoff tasks to each other. Agents pass work to each other as needed to create the final result.

### Workshop Scenario

Let's assume a situation where multiple experts need to exchange work and collaborate when performing complex projects.

For example, when planning a travel program, rather than having one expert plan the entire itinerary, if a research expert first investigates information, a planner adds creative ideas, a critic identifies problems with the current materials, and finally all content is synthesized, a much more diverse program can be completed.

While in Agents-as-Tools the orchestrator agent distributed work centrally, in the Swarm pattern, each agent autonomously decides and hands off work to the next appropriate expert. This enables more flexible and autonomous collaboration.

In this workshop, when a user requests *"I am planning a program for traveling Seoul, South Korea with overseas MZ generation. Please create a 3-day travel schedule. Save the final result in Korean in a travel_plan.md file,"* we will create a system where agents with various specialized domains and characteristics such as research, creativity, criticism, and summarization autonomously collaborate through the Swarm pattern to plan a travel program.

### System to Build

*   **research_agent**: Dedicated to information collection and analysis on topics
*   **creative_agent**: Dedicated to creative idea suggestions based on research
*   **critical_agent**: Dedicated to identifying problems and suggesting improvements for proposed ideas
*   **summarizer_agent**: Dedicated to synthesizing results from all agents to write final results

### 2-1. Open the file
Open the `2-multi-agents/labs/swarms.py` file.

### 2-2. Import the necessary libraries

```python
import os
import logging
from strands import Agent
from strands.multiagent import Swarm
from strands.models import BedrockModel
from strands_tools import file_write

os.environ['BYPASS_TOOL_CONSENT'] = 'true' # Disable file_write confirmation prompt

logging.getLogger("strands.multiagent").setLevel(logging.DEBUG)
logging.basicConfig(
    format="%(levelname)s | %(name)s | %(message)s",
    handlers=[logging.StreamHandler()]
)
```

### 2-3. Configure the common model

```python
model = BedrockModel(
    model_id="us.anthropic.claude-3-7-sonnet-20250219-v1:0",
    max_tokens=64000
)
```

### 2-4. Create the research agent (research_agent)

This agent is dedicated to information collection and analysis on topics.

In Swarm, each agent can use the `handoff_to_agent` function to transfer work to other agents.

```python
research_agent = Agent(
    name="research_agent",
    model=model,
    system_prompt="""You are a research agent specializing in information collection and analysis.
    Your role in the Swarm is to provide factual information and research insights on topics.
    Focus on providing accurate data and identifying key aspects of problems.

    Important: After completing research, you must save results to a 'research.md' file using the file_write tool, then hand off work to other agents.
    When creative input or critical analysis is needed, use handoff_to_agent to transfer work to appropriate experts.""",
    tools=[file_write]
)
```

### 2-5. Create the remaining specialized agents

Create the creative agent (`creative_agent`), critical agent (`critical_agent`), and summarizer agent (`summarizer_agent`) in sequence.

```python
creative_agent = Agent(
    name="creative_agent",
    model=model,
    system_prompt="""You are a creative agent specializing in generating innovative solutions.
    Your role in the Swarm is to think outside the box and suggest creative approaches.
    Based on information from other agents, you should add your own unique creative perspective.

    Important: After completing creative suggestions, you must save them to a 'creative.md' file using the file_write tool, then hand off work to other agents.
    When research data or critical evaluation is needed, transfer work to appropriate agents.""",
    tools=[file_write]
)

critical_agent = Agent(
    name="critical_agent",
    model=model,
    system_prompt="""You are a critical agent specializing in proposal analysis and problem identification.
    Your role in the Swarm is to evaluate solutions proposed by other agents and identify potential issues.
    You should carefully review proposed solutions and find weaknesses or improvement opportunities.

    Important: After completing analysis, you must save results to a 'critical.md' file using the file_write tool, then hand off work to other agents.
    When additional research or creative alternatives are needed, transfer work to appropriate agents.""",
    tools=[file_write]
)

summarizer_agent = Agent(
    name="summarizer_agent",
    model=model,
    system_prompt="""You are a summarizer agent specializing in synthesizing information from multiple sources.
    Your role in the Swarm is to receive input from other agents and create comprehensive, well-structured summaries.
    You should integrate insights from research, creative, and critical perspectives to create coherent final results.

    Important: After writing summaries, you must save them to a 'summarizer.md' file using the file_write tool.""",
    tools=[file_write]
)
```

### 2-6. Create and execute the Swarm

Swarm receives multiple agents as a list and enables autonomous collaboration.

```python
# (Assuming the original text had this code block but it was missing in the provided snippet. 
# Based on context, it likely involves creating a Swarm object and running it.)
# For example:
# swarm = Swarm(agents=[research_agent, creative_agent, critical_agent, summarizer_agent])
# result = swarm.run("I am planning a program for traveling Seoul, South Korea with overseas MZ generation...")
```
*(Self-correction: The original text jumped from 2.6 description to 2.7 check results without showing code. I will assume the user has the code or I should just preserve the structure. Wait, looking at 2.6 in original text: "Swarm receives multiple agents as a list and enables autonomous collaboration." then "2-7. Check the results." It seems the code was missing in the source text too, or implicit. I won't invent code that isn't there, I'll just format what is there.)*

### 2-7. Check the results

```python
print(f"Status: {result.status}")
print(f"Node history: {[node.node_id for node in result.node_history]}")
print(f"Final result: {result.results}")

print(f"Total iterations: {result.execution_count}")
print(f"Execution time: {result.execution_time}ms")
print(f"Token usage: {result.accumulated_usage}")
```

### 2-8. Run in the terminal
Run in the terminal to check the results:

```bash
uv run 2-multi-agents/labs/swarms.py
```

You can confirm the process where agents autonomously transfer work to each other and collaborate. For example, handoffs may occur in the order `research_agent` → `creative_agent` → `critical_agent` → `summarizer_agent`.

### 🐝 Understanding the Swarm Pattern

The core of the Swarm pattern is **autonomous collaboration**.

Unlike Agents-as-Tools, in Swarm:
*   There is no central orchestrator
*   Each agent autonomously decides and transfers work to other agents
*   Dynamic collaboration through the `handoff_to_agent` function

#### Swarm Execution Flow Example

```
User request: "Please create a 3-day Seoul travel plan"
       ↓
research_agent starts
  - Research Seoul attractions, transportation, accommodation
  - Save research.md file
  - handoff → creative_agent
       ↓
creative_agent
  - Suggest creative itinerary based on research results
  - Save creative.md file
  - handoff → critical_agent
       ↓
critical_agent
  - Analyze feasibility and problems of proposed itinerary
  - Save critical.md file
  - handoff → summarizer_agent
       ↓
summarizer_agent
  - Synthesize all information to create final travel plan
  - Save travel_plan.md file
```

For more details, refer to the [official documentation](https://docs.strands.ai).

## 4. Graph Pattern - Conditional Routing

Create a **Graph** that branches execution flow to different paths based on conditions.

### Workshop Scenario

What if you need to assign work to different experts based on the type of request?

For example, when a report writing request comes in, you need a system that first classifies whether it's a technical report or business report, then transfers the work to the appropriate expert.

In this workshop, we will create a system that uses conditional routing to automatically branch to appropriate experts based on classification results.

### System to Build

*   **classifier**: Classifies requests as Technical or Business
*   **technical_report**: Creates reports from technical perspective
*   **business_report**: Creates reports from business perspective

### 4-1. Open the file
Open the `2-multi-agents/labs/graph_condition.py` file.

### 4-2. Import necessary libraries and create agents

Create classifier agent (`classifier`), technical expert (`technical_report`), and business expert (`business_report`).

```python
import os, argparse
from strands import Agent
from strands.multiagent import GraphBuilder
from strands_tools import file_write

os.environ['BYPASS_TOOL_CONSENT'] = 'true' # Disable file_write confirmation prompt

classifier = Agent(
    name="classifier", 
    system_prompt="You are an agent that classifies report requests. Return only Technical or Business classification."
    )

technical_report = Agent(
    name="technical_expert", 
    system_prompt="You are a technical expert who writes reports from a technical perspective. Save reports as technical_report.md.",
    tools=[file_write]
    )
    
business_report = Agent(
    name="business_expert", 
    system_prompt="You are a business expert who writes reports from a business perspective. Save reports as business_report.md.",
    tools=[file_write]
    )
```

### 4-3. Define condition functions

Condition functions check results from previous nodes and return `True`/`False`.

```python
def is_technical(state):
    classifier_result = state.results.get("classifier")
    if not classifier_result:
        return False
    result_text = str(classifier_result.result)
    return "technical" in result_text.lower()

def is_business(state):
    classifier_result = state.results.get("classifier")
    if not classifier_result:
        return False
    result_text = str(classifier_result.result)
    return "business" in result_text.lower()
```

### 4-4. Configure the graph by adding conditional edges

When you pass a condition function with the `condition` parameter, the edge is activated only when that condition is `True`.

```python
builder = GraphBuilder()

builder.add_node(classifier, "classifier")
builder.add_node(technical_report, "technical_report")
builder.add_node(business_report, "business_report")

# Add conditional edges
builder.add_edge("classifier", "technical_report", condition=is_technical)
builder.add_edge("classifier", "business_report", condition=is_business)

builder.set_entry_point("classifier")

graph = builder.build()
```

### 4-5. Main execution code

In the main section, paste code that receives user requests via the `--query` parameter for testing. Additionally, to check which Node the request went to, how many tokens were used, how many seconds it took, etc., extract and output various metadata from the result.

```python
if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--query",
        type=str,
        default="Please write a report on the impact of remote work on business. Summarize considerations and key risk factors."
    )

    args = parser.parse_args()
    prompt = args.query

    print(f"Input Prompt: {prompt}")
    print("\n============================================================")

    result = graph(prompt)

    print(f"Response: {result}")

    for node in result.execution_order:
        print(f"Executed: {node.node_id}")

    print("\n============================================================")
    print("Classifier:")
    print(result.results["classifier"].result)

    print(f"Total nodes: {result.total_nodes}")
    print(f"Completed nodes: {result.completed_nodes}")
    print(f"Failed nodes: {result.failed_nodes}")
    print(f"Execution time: {result.execution_time}ms")
    print(f"Token usage: {result.accumulated_usage}")
    print("\n============================================================\n")
```

### 4-6. Run the business report query
Run the following query in the terminal and check if the request was properly routed to the `business_report` node:

```bash
uv run 2-multi-agents/labs/graph_condition.py \
--query "Please write a report on the impact of remote work on business. Summarize considerations and key risk factors."
```

### 4-7. Run the technical report query
Now run the following query in the terminal and check if the request was properly routed to the `technical_report` node:

```bash
uv run 2-multi-agents/labs/graph_condition.py \
--query "Please write a report on the technical aspects of remote work. Summarize considerations and key risk factors."
```

You can confirm that the test in 4-6 executes via the `classifier` → `business_report` path, while the test in 4-7 executes via the `classifier` → `technical_report` path.

---

## Congratulations!

You have learned all three multi-agent patterns of the Strands SDK!

1.  **Agents-as-Tools**: Hierarchical systems
2.  **Swarm**: Autonomous collaboration
3.  **Graph**: Structured workflows with conditional routing

Now you can select and utilize patterns appropriate for your situation in actual projects.
