# Catppuccin Mocha theme for Hyprland
{
  lib,
  customUtils,
  ...
}: let
  toRgb = color: "rgb(${lib.substring 1 6 (lib.strings.toLower color)})";
  theme = {
    flamingo = toRgb customUtils.catppuccin.flamingo;
    blue = toRgb customUtils.catppuccin.blue;
    surface2 = toRgb customUtils.catppuccin.surface2;
  };
in {
  wayland.windowManager.hyprland.settings = {
    general = {
      "col.active_border" = "${theme.blue} ${theme.flamingo} 90deg";
      "col.inactive_border" = theme.surface2;
    };
  };
}
