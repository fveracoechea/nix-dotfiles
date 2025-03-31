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
    dconf-editor
    gnome-tweaks
    gnome-system-monitor
    gnome-calculator
    gnome-control-center
    gnome-notes
    gnome-firmware
    gnome-monitor-config
    gnomeExtensions.freon
    gnomeExtensions.gamemode-shell-extension
    gnomeExtensions.tiling-shell
    gnomeExtensions.system-monitor
    gnomeExtensions.workspace-indicator
    gnomeExtensions.auto-move-windows
  ];
}
