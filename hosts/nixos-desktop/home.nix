{
  inputs,
  pkgs,
  ...
}: let
  customPkgs = import ../../packages pkgs;
in {
  imports = [
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/bat.nix
    ../../modules/home-manager/yazi.nix
    ../../modules/home-manager/oh-my-posh.nix
    ../../modules/home-manager/gnome.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/volta.nix
    ../../modules/home-manager/pro-audio.nix
    ../../modules/home-manager/fuzzel.nix
    ../../modules/home-manager/ghostty.nix
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/hyprpanel.nix
    ../../modules/home-manager/hyprlock.nix
    ../../modules/home-manager/hypridle.nix
    ../../modules/home-manager/sunshine.nix
    inputs.neovim-config.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.username = "fveracoechea";
  home.homeDirectory = "/home/fveracoechea";

  home.file.".face".source = ../../wallpapers/face.jpg;
  home.file.".face.icon".source = ../../wallpapers/face.jpg;

  programs.spicetify.enable = true;

  stylix.targets.neovim.enable = false;

  programs.cava.enable = true;
  stylix.targets.cava.rainbow.enable = true;

  # FPS hud for steam video-games
  programs.mangohud.enable = true;

  home.packages = with pkgs; [
    slack
    vesktop
    google-chrome
    kooha
    teams-for-linux
    btop
    nerd-fonts.fira-code
    python3
    dconf2nix
    nurl
    watchman
    ripgrep
    jq
    postman
    wireguard-tools
    lutgen
    customPkgs.dev-manager-desktop
    masterpdfeditor
  ];

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
