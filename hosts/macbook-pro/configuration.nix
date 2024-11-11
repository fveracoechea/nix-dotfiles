{pkgs, ...}: let
  username = "franciscoveracoechea";
in {
  # Used for backwards compatibility.
  system.stateVersion = 5;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

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
      mru-spaces = false;
      largesize = 80;
      tilesize = 48;
      magnification = true;
      mineffect = "genie";
      orientation = "left";
    };
  };

  # Homebrew - needs to be manually installed.
  homebrew = {
    enable = true;
    casks = [
      "postgres-unofficial"
      "postico"
      "docker"
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

    fonts = {
      serif = firaSans;
      sansSerif = firaSans;
      monospace = firaCode;
      emoji = firaCode;
    };
  };
}
