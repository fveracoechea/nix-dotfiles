{config, ...}: {
  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      loadModels = [
        "mistral:latest"
        "mistral-nemo:latest"
        "deepseek-r1:14b"
        "qwen3:14b"
        "qwen3-coder:latest"
        "devstral:latest"
      ];
      host = "0.0.0.0";
      port = 11434;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "16384";
        OLLAMA_NUM_PARALLEL = "2";
        OLLAMA_MAX_LOADED_MODELS = "2";
        OLLAMA_KEEP_ALIVE = "15m";
        CUDA_VISIBLE_DEVICES = "0";
      };
    };

    open-webui = {
      enable = true;
      port = 8888;
      host = "0.0.0.0";
      stateDir = "/var/lib/open-webui";
      environment = {
        OLLAMA_BASE_URL = "http://localhost:11434";
      };
    };
  };
}
