{
  system,
  pkgs,
  inputs,
  ...
}: let
  mcpPackages = inputs.mcp-servers-nix.packages.${system};
in {
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

      mcp = {
        fetch = {
          type = "local";
          enabled = true;
          command = ["docker" "run" "-i" "--rm" "mcp/fetch"];
        };
        memory = {
          type = "local";
          enabled = true;
          command = ["${mcpPackages.mcp-server-memory}/bin/mcp-server-memory"];
        };
        playwright = {
          type = "local";
          enabled = true;
          command = [
            "${mcpPackages.playwright-mcp}/bin/mcp-server-playwright"
            "--executable-path"
            "${pkgs.chromium}/bin/chromium"
          ];
        };
        sequential-thinking = {
          type = "local";
          enabled = true;
          command = ["${mcpPackages.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking"];
        };
        time = {
          type = "local";
          enabled = true;
          command = ["${mcpPackages.mcp-server-time}/bin/mcp-server-time"];
        };
      };
    };
  };
}
