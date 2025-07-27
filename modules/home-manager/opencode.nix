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
            "mistral:7b" = {
              tools = true;
              reasoning = true;
            };
            "llama3.1:8b" = {
              tools = true;
              reasoning = true;
            };
            "deepseek-r1:14b" = {
              tools = true;
              reasoning = true;
            };
          };
        };
      };
    };
  };
}
