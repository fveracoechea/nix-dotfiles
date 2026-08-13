{
  pkgs,
  dotfilesPkgs,
  ...
}: {
  dotfiles = {
    shell.enable = true;
    neovim.enable = true;
    gtk.enable = true;
    volta.enable = true;
    ghostty.enable = true;
    sunshine.enable = true;
    fonts.enable = true;
    mangohud.enable = true;
    spotify.enable = true;
    coding-agents.enable = true;
    desktop-entries.enable = true;
    pro-audio.enable = true;
    fuzzel.enable = true;
    hyprland = {
      enable = true;
      monitors = [
        "DP-1, 5120x1440@119.98Hz, auto, auto, bitdepth, 8, cm, auto"
        "HDMI-A-1, disable"
      ];
    };
  };

  home.username = "fveracoechea";
  home.homeDirectory = "/home/fveracoechea";

  home.file.".face".source = ../../assets/face.jpg;
  home.file.".face.icon".source = ../../assets/face.jpg;

  home.packages = with pkgs; [
    vesktop
    google-chrome
    kooha
    python3
    nurl
    postman
    lutgen
    beekeeper-studio
    dotfilesPkgs.dev-manager-desktop
    railway
    openlinkhub
    zettlr
    tiny-rdm
    obs-studio
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      hostinger = {
        HostName = "168.231.68.183";
        User = "fveracoechea";
        IdentityFile = "~/.ssh/fveracoechea";
      };
      homelab = {
        HostName = "10.0.0.2";
        User = "fveracoechea";
        IdentityFile = "~/.ssh/fveracoechea";
      };
      "github.com" = {
        User = "git";
        IdentitiesOnly = "yes";
        IdentityFile = "~/.ssh/id_github_hypr";
      };
    };
  };

  # DO NOT CHANGE
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
