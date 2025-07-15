{
  pkgs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    iconTheme = lib.mkForce {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
  };

  home.packages = with pkgs; [
    gnome-system-monitor
    gnome-calculator
    gnome-control-center
    gnome-notes
    gnome-firmware
    gnome-monitor-config
    loupe
  ];
}
