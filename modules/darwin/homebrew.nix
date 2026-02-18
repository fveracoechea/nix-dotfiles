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
      "pulumi/tap/pulumi"
      "python@3.12"
    ];
  };
}
