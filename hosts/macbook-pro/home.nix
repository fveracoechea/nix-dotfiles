{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/volta.nix
    ../../modules/home-manager/karabiner.nix
    inputs.neovim-config.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    watchman
    ripgrep
    wget
    neofetch
    cmatrix
    fira-code-nerdfont
    google-chrome
    postman
    slack
  ];

  # Link apps to Launchpad
  # home.activation = {
  #   rsync-home-manager-applications = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #     rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
  #     apps_source="$genProfilePath/home-path/Applications"
  #     moniker="Home Manager Trampolines"
  #     app_target_base="${config.home.homeDirectory}/Applications"
  #     app_target="$app_target_base/$moniker"
  #     mkdir -p "$app_target"
  #     ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
  #   '';
  # };

  # home.username = "franciscoveracoechea";
  # home.homeDirectory = /Users/franciscoveracoechea;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
