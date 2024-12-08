{
  pkgs,
  pkgs-stable,
  ...
}: {
  # FPS hud for steam video-games
  programs.mangohud.enable = true;

  home.packages = with pkgs; [
    # gui
    slack
    vesktop
    google-chrome
    kooha
    teams-for-linux

    # tui
    btop
    wego

    # fonts
    pkgs-stable.fira-code-nerdfont
    nerd-fonts.fira-code

    # dev
    deno
    python3

    # utils
    dconf2nix
    nurl
    watchman
    neofetch
    cmatrix
    ripgrep
  ];
}
