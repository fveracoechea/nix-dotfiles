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
      "ghostty"
      "docker"
      "postgres-unofficial"
      "karabiner-elements"
      # "displaylink"
      "moonlight"
    ];
    brews = [
      # "pipx"
      "pulumi/tap/pulumi"
      # "pyenv"
      "python@3.12"
    ];
  };
}
