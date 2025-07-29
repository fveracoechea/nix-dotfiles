{
  pkgs,
  inputs,
  config,
  utils,
  ...
}: let
  mcpConfig = utils.mcpServers {
    inherit pkgs inputs config;
  };
  # Convert mcp-servers-nix config to opencode format
  mcpConfigData = builtins.fromJSON (builtins.readFile mcpConfig);
  # Filter out filesystem and git servers for opencode
  filteredMcpData = builtins.removeAttrs mcpConfigData.mcpServers ["filesystem" "git"];
  # Transform for opencode mcp section
  toOpencodeMcpServers = builtins.mapAttrs (name: server: {
    type = "local";
    enabled = true;
    command = [server.command] ++ server.args or [];
  });
in {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    settings = {
      theme = "system";
      autoupdate = false;
      mcp = toOpencodeMcpServers filteredMcpData;
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
    };
  };
}
