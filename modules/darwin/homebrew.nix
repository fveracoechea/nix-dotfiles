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
      "docker-desktop"
      "karabiner-elements"
      "beekeeper-studio"
      "google-chrome"
      "microsoft-teams"
      "microsoft-outlook"
      "slack"
      "figma"
      "postman"
      # "moonlight"
      # "displaylink"
      # "postgres-unofficial"
    ];
    brews = [
      # "pipx"
      # "pyenv"
      # "python@3.12"
      "pulumi"
      "awscli"
    ];
  };
}
