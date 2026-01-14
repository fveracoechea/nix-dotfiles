{
  pkgs,
  lib,
  ...
}: {
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };

  gtk = {
    enable = true;
    iconTheme = lib.mkForce {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk.override {
        accent = ["default"];
        shade = "dark";
        tweaks = ["float"];
      };
    };
    font = {
      size = 12;
      package = pkgs.fira-sans;
      name = "Fira Sans";
    };
  };

  home.packages = with pkgs; [
    papers
    gnome-text-editor
    gnome-system-monitor
    gnome-calculator
    gnome-control-center
    gnome-notes
    gnome-firmware
    gnome-monitor-config
    loupe
    snapshot
  ];
}
