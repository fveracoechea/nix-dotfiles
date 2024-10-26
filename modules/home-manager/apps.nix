{pkgs, ...}: {
  home.packages = with pkgs; [
    slack
    vesktop
    google-chrome
    kooha

    # terminal
    ripgrep
    eza
    yazi
    btop
    lazygit
    oh-my-posh
    neofetch
    python3
    cmatrix

    # fonts
    fira-code-nerdfont

    # utils
    dconf2nix
    watchman

    # dev
    deno
  ];
}
