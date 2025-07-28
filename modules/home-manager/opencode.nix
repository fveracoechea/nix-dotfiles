{pkgs, ...}: {
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
            "mistral-nemo:latest" = {
              tools = true;
              reasoning = false;
            };
            "deepseek-r1:14b" = {
              tools = true;
              reasoning = true;
            };
            "qwen3:14b" = {
              tools = true;
              reasoning = true;
            };
          };
        };
      };
      mcp = let
        localhost = "http://localhost:8000";
      in {
        context7 = {
          type = "remote";
          enabled = true;
          url = "${localhost}/context7/openapi.json";
        };
        sequential-thinking = {
          type = "remote";
          enabled = true;
          url = "${localhost}/sequential-thinking/openapi.json";
        };
        playwright = {
          type = "remote";
          enabled = true;
          url = "${localhost}/playwright/openapi.json";
        };
      };
    };
  };
}
