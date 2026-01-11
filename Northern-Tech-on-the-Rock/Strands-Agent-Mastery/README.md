# Strands Agents SDK Workshop

Welcome to the **Strands Agents SDK Workshop**! 🚀

In this hands-on workshop, you will learn how to build powerful AI agents using the Strands SDK. We will start from a basic single agent and progress to complex multi-agent systems and real-world web applications.

## 📋 Prerequisites

Before starting, ensure you have the following:

*   **Python 3.12+** installed
*   **uv** package manager installed (recommended for fast setup)
*   **AWS Credentials** configured with access to **Amazon Bedrock** (Claude models enabled)

## 🛠️ Setup Instructions

1.  Clone this repository.
2.  Navigate to the setup directory and run the initialization script:

```bash
cd 0-setup
chmod +x ./create-uv-env.sh
./create-uv-env.sh myenv 3.12
cd ..
```

## 📚 Workshop Modules

This workshop is divided into three main modules. It is recommended to follow them in order.

### [Module 1: Building a Basic Single Agent](./Building%20a%20Basic%20Single%20Agent.md)
Start here! Learn the fundamentals of Strands SDK.
*   **Core Components:** Prompt, Model, Tools
*   **Custom Tools:** Creating your own tools with `@tool` decorator
*   **Integration:** Connecting to MCP (Model Context Protocol) servers
*   **Reasoning:** Enabling "Extended Thinking" with Claude models

### [Module 2: Multi-Agent Patterns](./Building%20Systems%20that%20Perform%20Complex%20Tasks%20through%20Multi-Agent%20Patterns.md)
Scale up to complex tasks by orchestrating multiple agents.
*   **Agents-as-Tools:** Hierarchical structures with a router agent
*   **Swarm Pattern:** Autonomous collaboration where agents hand off tasks to each other
*   **Graph Pattern:** Structured workflows with conditional routing

### [Module 3: Applying Agents to Real Chatbot Applications](./Applying%20Agents%20to%20Real%20Chatbot%20Applications.md)
Turn your agent into a real-world web application using **Streamlit**.
*   **Session State:** Managing conversation memory
*   **Asynchronous Streaming:** Displaying real-time responses
*   **UI/UX:** Visualizing tool calls and reasoning processes

## 📝 Summary

Check out the [Workshop Summary](./summary.md) for a quick recap of all key concepts, code snippets, and pattern selection guides.

## 🚀 Next Steps

Once you have completed the workshop, try to:
1.  Customize the agents for your specific business use case.
2.  Integrate more complex tools or external APIs.
3.  Deploy your Streamlit app to a hosting service.

Happy Coding! 🎉
