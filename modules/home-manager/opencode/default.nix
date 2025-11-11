{
  lib,
  system,
  pkgs,
  inputs,
  ...
}: let
  mcpPackages = inputs.mcp-servers-nix.packages.${system};
in {
  stylix.targets.opencode.enable = false;

  home.packages = [pkgs.lsof];

  programs.opencode = {
    enable = true;

    commands = {
      create-commit = ./command/create-commit.md;
      create-pr = ./command/create-pr.md;
    };

    settings = {
      theme = "system";
      autoupdate = true;
      provider =
        if pkgs.stdenv.isLinux
        then {
          ollama = {
            npm = "@ai-sdk/openai-compatible";
            options = {
              baseURL = "http://127.0.0.1:11434/v1";
            };
            models = {
              "qwen3:30b" = {
                tools = true;
                reasoning = true;
                description = "General purpose model with strong reasoning and multilingual capabilities";
              };
              "gpt-oss:20b" = {};
              "qwen3-coder:latest" = {
                tools = true;
                reasoning = true;
                description = "Small code generation and reasoning model";
              };
            };
          };
        }
        else {};

      mcp = {
        fetch = {
          enabled = true;
          type = "local";
          command = ["docker" "run" "-i" "--rm" "mcp/fetch"];
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
