{pkgs, ...}: let
  username = "franciscoveracoechea";
in {
  imports = [
    ../../modules/darwin/system-defaults.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/stylix.nix
    ../../modules/darwin/zsh-shell.nix
  ];

  system.primaryUser = username;

  # Used for backwards compatibility.
  system.stateVersion = 5;
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  users.users = {
    ${username} = {
      name = username;
      home = "/Users/${username}";
    };
  };

  # Currently not working as a system service - using homebrew instead
  services.karabiner-elements.enable = false;

  # Enable touch id
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;
}
