{pkgs, ...}: {
  home.packages = with pkgs; [
    # gui
    slack
    vesktop
    google-chrome
    kooha

    # tui
    btop
    wego

    # fonts
    fira-code-nerdfont

    # dev
    deno
    python3

    # utils
    dconf2nix
    nurl
    watchman
    oh-my-posh
    neofetch
    cmatrix
    ripgrep
  ];
}
