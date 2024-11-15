{pkgs, ...}: let
  username = "franciscoveracoechea";
in {
  imports = [
    ../../modules/darwin/system-defaults.nix
    ../../modules/darwin/homebrew.nix
    .../../modules/darwin/stylix.nix
  ];

  # Used for backwards compatibility.
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

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

  users.users = {
    ${username} = {
      name = username;
      home = "/Users/${username}";
    };
  };

  # Currently not working as a system service - using homebrew instead
  services.karabiner-elements.enable = false;

  # Enable ZSH has default shell
  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = with pkgs; [zsh];
}
