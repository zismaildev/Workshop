from mcp import stdio_client, StdioServerParameters
from strands import Agent
from strands.tools.mcp import MCPClient

stdio_mcp_client = MCPClient(lambda: stdio_client(
    StdioServerParameters(command="uvx",
                          args=["awslabs.aws-documentation-mcp-server@latest"]
                          )
))

if __name__ == "__main__":
    user_input = "What is the Amazon Bedrock pricing model? Please explain concisely."

    agent = Agent(tools=[stdio_mcp_client])
    response = agent(user_input) 
