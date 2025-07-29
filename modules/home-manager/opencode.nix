{pkgs, sharedMcpConfig, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    settings = {
      theme = "system";
      autoupdate = false;
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "http://127.0.0.1:11434/v1";
          };
          models = {
            "qwen3:14b" = {
              tools = true;
              reasoning = true;
              description = "General purpose model with strong reasoning and multilingual capabilities";
            };
            "devstral:latest" = {
              tools = true;
              reasoning = true;
              description = "An agentic LLM for software engineering tasks";
            };
            "deepseek-r1:14b" = {
              tools = true;
              reasoning = true;
              description = "Advanced reasoning model with chain-of-thought capabilities";
            };
          };
        };
      };
      mcp = sharedMcpConfig.opencodeServers;
    };
  };
}
