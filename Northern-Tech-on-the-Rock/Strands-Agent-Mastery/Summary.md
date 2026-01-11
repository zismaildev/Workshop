# Workshop Summary

Congratulations! You have completed the Strands Agents SDK Workshop.

## Key Learning Content

### 1. Basic Single Agent

*   Creating agents with Strands SDK
*   Utilizing built-in tools and custom tools
*   Model configuration and Extended Thinking features
*   MCP tool integration

### 2. Multi-Agent Patterns

*   **Agents-as-Tools:** Building hierarchical systems by wrapping agents as tools
*   **Swarm:** Autonomous collaboration and handoff among agents
*   **Graph:** Explicit workflow definition (basic/conditional/parallel)

### 3. Web Application

*   Implementing chatbot UI with Streamlit
*   Session state management and asynchronous streaming
*   Real-time visualization of tool calling processes

## Core Pattern Summary

### Agent Creation

```python
agent = Agent(tools=[calculator, current_time])
agent = Agent(model=custom_model, tools=[...], system_prompt="...")
```

### Tool Definition

```python
# Built-in
from strands_tools import calculator

# Custom
@tool
def my_tool(param: str) -> str:
    return f"Result: {param}"

# MCP
with mcp_client:
    tools = mcp_client.list_tools_sync()
    agent = Agent(tools=tools)
```

### Multi-Agent

```python
# Agents-as-Tools
@tool
def specialist(query: str) -> str:
    return str(Agent(system_prompt="...")(query))

# Swarm
swarm = Swarm([agent1, agent2], max_handoffs=20)

# Graph
builder = GraphBuilder()
builder.add_node(agent, "node1")
builder.add_edge("node1", "node2")
graph = builder.build()
```

### Pattern Selection Guide

| Pattern | When to Use | Example |
| :--- | :--- | :--- |
| **Agents-as-Tools** | Clear role division needed | Customer support (router + specialists) |
| **Swarm** | Creative collaboration needed | Content creation (research + writing + review) |
| **Graph** | Structured processes | Report generation (collection → analysis → reporting) |

## Next Steps

### Practical Application

*   Customize agents for business scenarios
*   Integrate additional tools and MCP servers
*   Write company-specific prompts

### Advanced Learning

*   [Strands SDK Official Documentation](https://docs.strands.ai)
*   [Amazon Bedrock User Guide](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html)
*   [Multi-Agent Pattern Guide](https://docs.strands.ai/patterns)

### Extension Ideas

*   Integrate various MCP servers ([AWS MCP](https://github.com/awslabs/mcp-server-aws))
*   Real-time data pipeline integration
*   Build more complex Graph workflows

## Resource Cleanup

When using personal accounts, delete created resources to prevent unnecessary costs:

*   Delete CloudFormation stacks
*   Stop/delete SageMaker notebook instances

### Thank you! 🎉