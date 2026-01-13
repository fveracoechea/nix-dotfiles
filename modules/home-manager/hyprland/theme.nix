# Catppuccin Mocha theme for Hyprland
{...}: let
  theme = {
    flamingo = "rgb(f2cdcd)";
    blue = "rgb(89b4fa)";
    surface2 = "rgb(585b70)";
  };
in {
  wayland.windowManager.hyprland.settings = {
    general = {
      "col.active_border" = "${theme.blue} ${theme.flamingo}";
      "col.inactive_border" = theme.surface2;
    };
  };
}
