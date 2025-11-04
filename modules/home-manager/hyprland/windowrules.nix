{...}: let
  floatingClasses = builtins.concatStringsSep "|" [
    "blueberry.py"
    "Impala"
    "Wiremix"
    "org.gnome.NautilusPreviewer"
    "com.gabm.satty"
    "TUI.float"
  ];

  floatingTitles = builtins.concatStringsSep "|" ["Open.*Files?" "Open Folder" "Save.*Files?" "Save.*As" "Save" "All Files"];

  floatingClassesWithTitle = builtins.concatStringsSep "|" [
    "xdg-desktop-portal-gtk"
    "DesktopEditors"
    "org.gnome.Nautilus"
  ];
in {
  wayland.windowManager.hyprland.settings.windowrule = [
    "float, tag:floating-window"
    "center, tag:floating-window"
    "size 1024 768, tag:floating-window"

    "tag +floating-window, class:(${floatingClasses})"
    "tag +floating-window, class:(${floatingClassesWithTitle}), title:^(${floatingTitles})"

    "bordersize 0, fullscreen:1"
    "idleinhibit fullscreen, class:^(.*)$"
  ];
}
