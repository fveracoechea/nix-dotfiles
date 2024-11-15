{pkgs, ...}: let
  username = "franciscoveracoechea";
in {
  # Used for backwards compatibility.
  system.stateVersion = 5;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users = {
    ${username} = {
      name = username;
      home = "/Users/${username}";
    };
  };

  # System settings
  system.defaults = {
    finder.AppleShowAllExtensions = true;
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      mru-spaces = false;
      largesize = 65;
      tilesize = 35;
      magnification = true;
      mineffect = "genie";
      orientation = "bottom";
    };
  };

  # Currently not working as a system service
  services.karabiner-elements.enable = false;

  # Enable ZSH has default shell
  programs.zsh.enable = true;

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

  stylix = let
    firaSans = {
      package = pkgs.fira-sans;
      name = "Fira Sans";
    };
    firaCode = {
      package = pkgs.fira-code-nerdfont;
      name = "FiraCode Nerd Font";
    };
  in {
    enable = true;
    autoEnable = true;
    image = ../../config/wallpapers/Cloudsday.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    opacity.terminal = 0.9;

    fonts = {
      serif = firaSans;
      sansSerif = firaSans;
      monospace = firaCode;
      emoji = firaCode;
    };
  };
}
