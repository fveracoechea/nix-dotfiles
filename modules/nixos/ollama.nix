{
  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      loadModels = ["mistral:latest" "mistral-nemo:latest" "deepseek-r1:14b" "qwen3:14b"];
      host = "0.0.0.0";
      port = 11434;
      environmentVariables = {
        OLLAMA_NUM_PARALLEL = "2";
        OLLAMA_MAX_LOADED_MODELS = "2";
        OLLAMA_KEEP_ALIVE = "1h";
      };
    };

    open-webui = {
      enable = true;
      port = 8888;
      host = "0.0.0.0";
      environment = {
        OLLAMA_BASE_URL = "http://localhost:11434";
      };
    };
  };
}
