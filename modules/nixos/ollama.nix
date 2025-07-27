{
  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      loadModels = ["mistral:7b" "deepseek-r1:14b" "llama3.2-vision:11b" "llama3.1:8b"];
      host = "0.0.0.0";
      port = 11434;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "8192";
        OLLAMA_NUM_PARALLEL = "4";
        OLLAMA_MAX_LOADED_MODELS = "3";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KEEP_ALIVE = "24h";
      };
    };

    open-webui = {
      enable = true;
      port = 8888;
      host = "0.0.0.0";
      environment = {
        OLLAMA_BASE_URL = "http://localhost:11434";
        WEBUI_AUTH = "False";
      };
    };
  };
}
