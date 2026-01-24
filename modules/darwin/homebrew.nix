{...}: {
  # Homebrew - needs to be manually installed.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    casks = [
      "docker"
      "karabiner-elements"
      # "beekeeper-studio"
      # "moonlight"
      # "displaylink"
      # "postgres-unofficial"
    ];
    brews = [
      # "pipx"
      # "pyenv"
      "pulumi/tap/pulumi"
      "python@3.12"
    ];
  };
}
