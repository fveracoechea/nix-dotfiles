{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/oh-my-posh.nix
    ../../modules/home-manager/gnome.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/volta.nix
    ../../modules/home-manager/pro-audio.nix
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/waybar.nix
    ../../modules/home-manager/fuzzel.nix
    ../../modules/home-manager/mako.nix
    ../../modules/home-manager/ghostty.nix
    inputs.neovim-config.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.username = "fveracoechea";
  home.homeDirectory = "/home/fveracoechea";

  programs.spicetify.enable = true;
  stylix.targets.neovim.enable = false;
  stylix.targets.mako.enable = false;
  stylix.targets.waybar.enable = false;

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
    deno
    python3
    dconf2nix
    nurl
    watchman
    fastfetch
    cmatrix
    ripgrep
    jq
    postman
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
