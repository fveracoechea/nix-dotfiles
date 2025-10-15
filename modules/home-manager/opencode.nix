{
  lib,
  system,
  pkgs,
  inputs,
  customPkgs,
  ...
}: let
  mcpPackages = inputs.mcp-servers-nix.packages.${system};
in {
  programs.opencode = {
    enable = true;
    package = customPkgs.opencode;
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
            "qwen3-coder:latest" = {
              tools = true;
              # reasoning = true;
              description = "Performant long context models for agentic and coding tasks";
            };
            "mistral-small3.2:latest" = {
              tools = true;
              reasoning = true;
              description = "Highly capable model for general tasks";
            };
            "devstral:latest" = {
              tools = true;
              reasoning = true;
              description = "An agentic LLM for software engineering tasks";
            };
          };
        };
      };

      mcp = {
        fetch = {
          enabled = true;
          type = "local";
          command = ["docker" "run" "-i" "--rm" "mcp/fetch"];
        };
        memory = {
          enabled = true;
          type = "local";
          command = ["${mcpPackages.mcp-server-memory}/bin/mcp-server-memory"];
        };
        playwright = {
          enabled = true;
          type = "local";
          command =
            [
              "${mcpPackages.playwright-mcp}/bin/mcp-server-playwright"
              "--executable-path"
            ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              "${pkgs.chromium}/bin/chromium"
            ]
            ++ lib.optionals pkgs.stdenv.isDarwin [
              "${pkgs.google-chrome}/bin/google-chrome-stable"
            ];
        };
        sequential-thinking = {
          enabled = true;
          type = "local";
          command = ["${mcpPackages.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking"];
        };
        time = {
          enabled = true;
          type = "local";
          command = ["${mcpPackages.mcp-server-time}/bin/mcp-server-time"];
        };
        grep = {
          enabled = true;
          type = "remote";
          url = "https://mcp.grep.app";
        };
      };
    };
  };
}
