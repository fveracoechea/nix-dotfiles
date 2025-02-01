{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/oh-my-posh.nix
    ../../modules/home-manager/volta.nix
    ../../modules/home-manager/karabiner.nix
    ../../modules/home-manager/ghostty.nix
    inputs.neovim-config.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    watchman
    ripgrep
    wget
    fastfetch
    cmatrix
    google-chrome
    postman
    slack
    nerd-fonts.fira-code
    lazydocker
  ];

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
