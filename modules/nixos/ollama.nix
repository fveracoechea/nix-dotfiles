{
  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      loadModels = ["mistral:7b" "deepseek-r1:14b" "llama3.2-vision:90b"];
    };

    open-webui = {
      enable = true;
      port = 8888;
    };
  };
}
