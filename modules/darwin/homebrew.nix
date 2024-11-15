{...}: {
  # Homebrew - needs to be manually installed.
  homebrew = {
    enable = true;
    casks = [
      "postgres-unofficial"
      "karabiner-elements"
      "displaylink"
    ];
    brews = [
      "pipx"
      "postgresql@14"
      "pulumi/tap/pulumi"
      "pyenv"
      "python@3.12"
    ];
  };
}
