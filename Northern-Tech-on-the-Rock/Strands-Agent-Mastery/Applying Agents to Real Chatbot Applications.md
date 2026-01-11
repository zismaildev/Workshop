# 3. Applying Agents to Real Chatbot Applications

In this workshop, we will learn how to convert Strands agents that were running in the terminal into Streamlit web applications.

## Workshop Introduction

We will turn the agents we've created so far into chatbot applications that real users can use. Beyond simply adding a UI, we will implement core features needed for real applications such as session management, asynchronous processing, and streaming responses.

### Learning Objectives:

*   Implement chatbot UI with Streamlit
*   Manage conversation history with session state
*   Display real-time responses with asynchronous streaming
*   Visualize tool calling processes

## Terminal Execution vs Web Application

First, let's understand the difference between our `basic.py` and `streamlit_app.py` which converts it to a web application.

### basic.py (Terminal Execution)

```python
from strands import Agent
from strands_tools import calculator, current_time, use_aws, python_repl

agent = Agent(tools=[calculator, current_time, use_aws, python_repl])
response = agent("What is 80/4?")
print(response)
```

**Characteristics:**
*   Ends with a single question and answer
*   Waits until results are ready (synchronous method)
*   Cannot remember previous conversations
*   Only outputs results to terminal

### streamlit_app.py (Web Application)

**Characteristics:**
*   Multiple questions and answers possible
*   Real-time viewing of response generation process (asynchronous streaming)
*   Maintains conversation history
*   Visually displays tool calling processes

### View completed `streamlit_app.py` Code

```python
import streamlit as st
from strands import Agent
from strands_tools import calculator, current_time, use_aws, python_repl
import json
import asyncio

# Page configuration
st.set_page_config(
    page_title="Strands Agent Chatbot",
    page_icon="🤖",
    layout="centered"
)

# Title
st.title("🤖 Strands Agent Chatbot")

# Agent initialization (stored in session state)
if "agent" not in st.session_state:
    st.session_state.agent = Agent(tools=[calculator, current_time, use_aws, python_repl])

# Chat history initialization
if "messages" not in st.session_state:
    st.session_state.messages = []

# Display chat history
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        if message["role"] == "user":
            st.markdown(message["content"])
        else:
            # Display thinking process
            if message.get("thinking_steps"):
                with st.expander("🧠 View Thinking Process", expanded=False):
                    for step in message["thinking_steps"]:
                        st.markdown(step)
            # Display final response
            st.markdown(message["content"])

# User input
if prompt := st.chat_input("Enter your message..."):
    # Add and display user message
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    # Generate Assistant response
    with st.chat_message("assistant"):
        # Create main container
        main_container = st.container()

        try:
            # Define async function
            async def run_agent():
                final_response = ""
                current_text = ""
                tool_info = {}
                current_text_box = None

                # Execute Agent stream
                agent_stream = st.session_state.agent.stream_async(prompt)

                async for event in agent_stream:
                    # Text streaming
                    if "data" in event:
                        text = event["data"]
                        current_text += text

                        # Create new text box if none exists
                        if current_text_box is None:
                            with main_container:
                                current_text_box = st.empty()

                        # Display current text in text box
                        current_text_box.info(current_text)

                    # Tool call information
                    elif "current_tool_use" in event:
                        # Finish current text box if exists
                        if current_text:
                            current_text_box = None
                            current_text = ""

                        current_tool_use = event["current_tool_use"]
                        tool_name = current_tool_use.get("name", "")
                        tool_input = current_tool_use.get("input", {})
                        tool_use_id = current_tool_use.get("toolUseId", "")

                        # Store tool information
                        if tool_use_id not in tool_info:
                            tool_info[tool_use_id] = {
                                "name": tool_name,
                                "input": tool_input,
                                "result": None
                            }

                            # Display tool call in real-time
                            with main_container:
                                if tool_input:
                                    st.warning(f"🔧 **Tool Call:** `{tool_name}`\n\n**Input:**\n```json\n{json.dumps(tool_input, indent=2, ensure_ascii=False)}\n```")
                                else:
                                    st.warning(f"🔧 **Tool Call:** `{tool_name}`")

                    # Tool results
                    elif "message" in event:
                        message = event["message"]
                        if "content" in message:
                            content = message["content"]
                            if content and "toolResult" in content[0]:
                                tool_result = content[0]["toolResult"]
                                tool_use_id = tool_result["toolUseId"]
                                tool_content = tool_result["content"]
                                result_text = tool_content[0].get("text", "") if tool_content else ""

                                # Store and display tool results
                                if tool_use_id in tool_info:
                                    tool_info[tool_use_id]["result"] = result_text

                                    with main_container:
                                        st.success(f"✅ **Tool Result:** {result_text[:200]}...")

                    # Final result
                    elif "result" in event:
                        # Finish current text box if exists
                        if current_text:
                            current_text_box = None

                        final = event["result"]
                        message = final.message
                        if message:
                            content = message.get("content", [])
                            if content:
                                final_response = content[0].get("text", "")

                return final_response, tool_info

            # Execute async function
            final_response, tool_info = asyncio.run(run_agent())

            # Display final response (as plain text)
            with main_container:
                st.markdown("---")
                st.markdown(final_response)

            # Save message (including reasoning information)
            reasoning_text = ""
            if tool_info:
                reasoning_text = "### 🔧 Tools Used\n\n"
                for tool_id, info in tool_info.items():
                    reasoning_text += f"**Tool Name:** `{info['name']}`\n\n"
                    reasoning_text += f"**Input:** `{json.dumps(info['input'], ensure_ascii=False)}`\n\n"
                    if info['result']:
                        reasoning_text += f"**Result:** {info['result'][:200]}...\n\n"
                    reasoning_text += "---\n\n"

            st.session_state.messages.append({
                "role": "assistant",
                "content": final_response,
                "thinking_steps": [reasoning_text] if reasoning_text else None
            })

        except Exception as e:
            import traceback
            error_message = f"An error occurred: {str(e)}\n\n```\n{traceback.format_exc()}\n```"
            st.error(error_message)
            st.session_state.messages.append({"role": "assistant", "content": f"Error: {str(e)}"})

# Additional information in sidebar
with st.sidebar:
    st.header("ℹ️ Information")
    st.markdown("""
    **Available Tools:**
    - 🧮 Calculator: Mathematical calculations
    - ⏰ Current Time: Current time
    - ☁️ AWS: AWS operations
    - 🐍 Python REPL: Python code execution

    **Example Questions:**
    - "What is 80 divided by 4?"
    - "Tell me the current time"
    - "Calculate the square root of 10"
    """)

    if st.button("Reset Conversation"):
        st.session_state.messages = []
        st.rerun()
```

## 1. Streamlit Basic Configuration

### 1-1. Create and open the file
Create and open the `1-basic-agent/labs/streamlit_app.py` file.

### 1-2. Import necessary libraries and configure the page

```python
import streamlit as st
from strands import Agent
from strands_tools import calculator, current_time, use_aws, python_repl
import json
import asyncio

# Page configuration
st.set_page_config(
    page_title="Strands Agent Chatbot",
    page_icon="🤖",
    layout="centered"
)

# Title
st.title("🤖 Strands Agent Chatbot")
```

`st.set_page_config()` sets the browser tab title, icon, and layout.

## 2. Session State Management

In web applications, the page is re-executed every time a user sends a new message. To maintain the agent and conversation history, you need to use session state.

### 2-1. Store the agent in session state

```python
# Agent initialization (stored in session state)
if "agent" not in st.session_state:
    st.session_state.agent = Agent(tools=[calculator, current_time, use_aws, python_repl])
```

`st.session_state` is a dictionary that maintains values even when the page is re-executed. Create the agent once and continue reusing it.

### 2-2. Initialize conversation history

```python
# Chat history initialization
if "messages" not in st.session_state:
    st.session_state.messages = []
```

Store conversation content in a list so previous conversations can be displayed on screen.

> **💡 Why Session State is Needed**
>
> Streamlit re-executes the Python script from start to finish every time a user clicks a button or provides input.
>
> **Without session state?**
> ```python
> agent = Agent(tools=[...])  # Created anew every time
> messages = []  # Initialized as empty list every time
> ```
> This would result in:
> *   Agent being created anew every time, which is inefficient
> *   Conversation history being initialized, making previous conversations invisible
>
> Using `st.session_state` allows you to maintain values during the user's browser session.

## 3. Display Conversation History

### 3-1. Display saved conversations on screen

```python
# Display chat history
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        if message["role"] == "user":
            st.markdown(message["content"])
        else:
            # Display thinking process
            if message.get("thinking_steps"):
                with st.expander("🧠 View Thinking Process", expanded=False):
                    for step in message["thinking_steps"]:
                        st.markdown(step)
            # Display final response
            st.markdown(message["content"])
```

`st.chat_message()` displays chat messages in speech bubble format. If role is "user", it displays on the right; if "assistant", it displays on the left.

## 4. Receiving User Input

### 4-1. Receive messages from users

```python
# User input
if prompt := st.chat_input("Enter your message..."):
    # Add and display user message
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)
```

`st.chat_input()` displays a message input field at the bottom of the screen. When the user presses enter, the input content is stored in the `prompt` variable and the `if` block is executed.

## 5. Asynchronous Streaming Response Processing

This is the most crucial part. We stream the agent's response in real-time to show it to users.

### What is Asynchronous Processing?

**Typical synchronous method:**
```python
response = agent("question")  # Wait until response is complete (10 seconds)
print(response)  # Output all at once after 10 seconds
```

**Asynchronous streaming method:**
```python
async for event in agent.stream_async("question"):  # Receive response generation process in real-time
    print(event)  # "Hel" → "lo" → " wo" → "rld" (real-time output)
```

`st.container()` creates a space where content can be added dynamically later.

### 5-2. Define asynchronous function

```python
        try:
            # Define async function
            async def run_agent():
                final_response = ""
                current_text = ""
                tool_info = {}
                current_text_box = None

                # Execute Agent stream
                agent_stream = st.session_state.agent.stream_async(prompt)
```

`async def` is a keyword for defining asynchronous functions. `stream_async()` allows receiving agent responses in real-time.

### 5-3. Process events

```python
                async for event in agent_stream:
                    # Text streaming
                    if "data" in event:
                        text = event["data"]
                        current_text += text

                        # Create new text box if none exists
                        if current_text_box is None:
                            with main_container:
                                current_text_box = st.empty()

                        # Display current text in text box
                        current_text_box.info(current_text)
```

`async for` receives and processes asynchronously occurring events one by one.

### 📤 Understanding Streaming Events

`stream_async()` generates various types of events during the agent's work process:

#### Event Types and Processing Methods

**1. "data" Event - Text Streaming**
```json
{"data": "Hello"}
{"data": " world"}
```
Text generated by the agent is delivered piece by piece. Accumulate this and display in blue box.

**2. "current_tool_use" Event - Tool Call Start**
```json
{
  "current_tool_use": {
    "name": "calculator",
    "input": {"expression": "80/4"},
    "toolUseId": "abc123"
  }
}
```
Occurs when the agent starts using a tool. You can know which tool is being called with what input.

**3. "message" Event - Tool Execution Result**
```json
{
  "message": {
    "content": [{
      "toolResult": {
        "toolUseId": "abc123",
        "content": [{"text": "20"}]
      }
    }]
  }
}
```
Tool execution is completed and results are delivered.

**4. "result" Event - Final Response**
```json
{
  "result": {
    "message": {
      "content": [{"text": "80 divided by 4 equals 20."}]
    }
  }
}
```
The agent's final response is delivered.

#### Real-time Processing Flow

```
User: "What is 80 divided by 4?"
    ↓
[data] "80"          → Screen: "80" (blue box)
[data] " divided"    → Screen: "80 divided" (update)
[current_tool_use]  → Screen: "🔧 calculator call" (orange box)
[message]           → Screen: "✅ Result: 20" (green box)
[data] " by 4"      → Screen: " by 4" (blue box)
[data] " equals 20" → Screen: " by 4 equals 20" (update)
[result]            → Final response complete
```

### 5-4. Process tool call events

```python
                    # Tool call information
                    elif "current_tool_use" in event:
                        # Finish current text box if exists
                        if current_text:
                            current_text_box = None
                            current_text = ""

                        current_tool_use = event["current_tool_use"]
                        tool_name = current_tool_use.get("name", "")
                        tool_input = current_tool_use.get("input", {})
                        tool_use_id = current_tool_use.get("toolUseId", "")

                        # Store tool information
                        if tool_use_id not in tool_info:
                            tool_info[tool_use_id] = {
                                "name": tool_name,
                                "input": tool_input,
                                "result": None
                            }

                            # Display tool call in real-time
                            with main_container:
                                if tool_input:
                                    st.warning(f"🔧 **Tool Call:** `{tool_name}`\n\n**Input:**\n```json\n{json.dumps(tool_input, indent=2, ensure_ascii=False)}\n```")
                                else:
                                    st.warning(f"🔧 **Tool Call:** `{tool_name}`")
```

When calling tools, display with orange warning box so users can see what the agent is doing.

### 5-5. Process tool result events

```python
                    # Tool results
                    elif "message" in event:
                        message = event["message"]
                        if "content" in message:
                            content = message["content"]
                            if content and "toolResult" in content[0]:
                                tool_result = content[0]["toolResult"]
                                tool_use_id = tool_result["toolUseId"]
                                tool_content = tool_result["content"]
                                result_text = tool_content[0].get("text", "") if tool_content else ""

                                # Store and display tool results
                                if tool_use_id in tool_info:
                                    tool_info[tool_use_id]["result"] = result_text

                                    with main_container:
                                        st.success(f"✅ **Tool Result:** {result_text[:200]}...")
```

When tool execution is complete, display results with green success box.

### 5-6. Process final results

```python
                    # Final result
                    elif "result" in event:
                        # Finish current text box if exists
                        if current_text:
                            current_text_box = None

                        final = event["result"]
                        message = final.message
                        if message:
                            content = message.get("content", [])
                            if content:
                                final_response = content[0].get("text", "")

                return final_response, tool_info
```

Return final response text and tool usage information.

### 5-7. Execute asynchronous function

```python
            # Execute async function
            final_response, tool_info = asyncio.run(run_agent())
```

`asyncio.run()` executes the asynchronous function and waits for results. All streaming processing proceeds until this function completes.

### 🔄 Understanding asyncio.run()

`asyncio.run()` acts as a bridge that allows asynchronous functions to be executed in synchronous environments (regular Python code).

```python
# Define async function
async def run_agent():
    async for event in agent.stream_async(prompt):
        # Process events...
    return result

# Execute async function in regular code
result = asyncio.run(run_agent())  # Wait until async function completes
```

**Why is it needed?**

1.  Streamlit basically runs in synchronous environment
2.  But the agent's `stream_async()` is an asynchronous function
3.  `asyncio.run()` connects these two

**Internal operation:**
1.  Create asynchronous event loop
2.  Execute `run_agent()` function in event loop
3.  Wait until function completes
4.  Return result

## 6. Display and Save Results

### 6-1. Display final response

```python
            # Display final response (as plain text)
            with main_container:
                st.markdown("---")
                st.markdown(final_response)
```

### 6-2. Organize tool usage information

```python
            # Save message (including reasoning information)
            reasoning_text = ""
            if tool_info:
                reasoning_text = "### 🔧 Tools Used\n\n"
                for tool_id, info in tool_info.items():
                    reasoning_text += f"**Tool Name:** `{info['name']}`\n\n"
                    reasoning_text += f"**Input:** `{json.dumps(info['input'], ensure_ascii=False)}`\n\n"
                    if info['result']:
                        reasoning_text += f"**Result:** {info['result'][:200]}...\n\n"
                    reasoning_text += "---\n\n"
```

### 6-3. Save to conversation history

```python
            st.session_state.messages.append({
                "role": "assistant",
                "content": final_response,
                "thinking_steps": [reasoning_text] if reasoning_text else None
            })
```

By storing tool usage information in `thinking_steps`, you can check it in the "View Thinking Process" expander when displaying conversation history later.

## 7. Error Handling

### 7-1. Handle exceptions

```python
        except Exception as e:
            import traceback
            error_message = f"An error occurred: {str(e)}\n\n```\n{traceback.format_exc()}\n```"
            st.error(error_message)
            st.session_state.messages.append({"role": "assistant", "content": f"Error: {str(e)}"})
```

Even if errors occur, the application doesn't crash but displays error messages to users and continues running.

## 8. Add Sidebar

### 8-1. Add information and features to the sidebar

```python
# Additional information in sidebar
with st.sidebar:
    st.header("ℹ️ Information")
    st.markdown("""
    **Available Tools:**
    - 🧮 Calculator: Mathematical calculations
    - ⏰ Current Time: Current time
    - ☁️ AWS: AWS operations
    - 🐍 Python REPL: Python code execution

    **Example Questions:**
    - "What is 80 divided by 4?"
    - "Tell me the current time"
    - "Calculate the square root of 10"
    """)

    if st.button("Reset Conversation"):
        st.session_state.messages = []
        st.rerun()
```

`st.rerun()` refreshes the page to immediately reflect changes.

## 9. Running

### 9-1. Run the Streamlit application in terminal

```bash
uv run streamlit run 1-basic-agent/labs/streamlit_app.py
```

`http://localhost:8501` will automatically open in browser, displaying the chatbot interface.

### 9-2. Test the chatbot:

1.  Enter "What is 80 divided by 4?"
2.  Check the process of agent calling calculator tool
3.  Check real-time response generation process
4.  Click "View Thinking Process" to check tool usage information

## Review of Key Concepts from This Workshop

### 📊 Overall Execution Flow

**Step-by-Step Execution Process**

**1. Initialization Stage:**
```
App start
  ↓
Page configuration
  ↓
Agent initialization (session check)
  ↓
Message history initialization (session check)
  ↓
Display previous conversations
```

**2. User Input Processing:**
```
User enters "What is 80 divided by 4?"
  ↓
Add message to history
  ↓
Display user message on screen
```

**3. Asynchronous Streaming Execution:**
```
Start run_agent() async function
  ↓
Call stream_async()
  ↓
Start event loop
  │
  ├─ [data] "80" → Display on screen
  ├─ [data] " divided by 4 is" → Update screen
  ├─ [current_tool_use] calculator → Display "🔧 Tool Call"
  ├─ [message] Result: 20 → Display "✅ Tool Result"
  ├─ [data] " 20" → Update screen
  └─ [result] Final response → End function
  ↓
Return final_response, tool_info
```

**4. Display and Save Results:**
```
Display final response on screen
  ↓
Organize tool usage information
  ↓
Save to history
  ↓
Page re-rendering
```

---

## Congratulations!

You have learned how to convert agents that were running in terminal into web applications that real users can use. You have acquired core technologies needed for real applications such as **session management**, **asynchronous streaming**, and **event processing**.