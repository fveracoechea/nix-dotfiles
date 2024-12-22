{pkgs, ...}: let
  username = "franciscoveracoechea";
in {
  imports = [
    ../../modules/darwin/system-defaults.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/stylix.nix
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
    # Enable the Flakes feature and the accompanying new nix command-line tool
    settings. experimental-features = ["nix-command" "flakes"];

    # optimise store
    optimise.automatic = true;

    # Enable automatic garbage collection
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

  security.pam.enableSudoTouchIdAuth = true;

  # Enable ZSH has default shell
  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = with pkgs; [zsh];
  programs.bash.enable = false;
}
