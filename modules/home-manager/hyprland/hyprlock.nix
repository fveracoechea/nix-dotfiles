{
  lib,
  customUtils,
  ...
}: let
  toRgb = color: "rgb(${lib.substring 1 6 (lib.strings.toLower color)})";
  theme = {
    blue = toRgb customUtils.catppuccin.blue;
    lavender = toRgb customUtils.catppuccin.lavender;
    surface0 = toRgb customUtils.catppuccin.surface0;
    surface1 = toRgb customUtils.catppuccin.surface1;
    red = toRgb customUtils.catppuccin.red;
    yellow = toRgb customUtils.catppuccin.yellow;
    text = toRgb customUtils.catppuccin.text;
  };
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = lib.mkForce [
        {
          path = "$HOME/dotfiles/assets/wallpapers/dark-forrest-ultrawide.png";
          blur_passes = 1;
          blur_size = 4;
        }
      ];

      label = [
        {
          text = "cmd[update:5000] echo $(date '+%I:%M %p')";
          font_size = 44;
          halign = "center";
          valign = "center";
          position = "0, 250";
        }
        {
          text = "cmd[update:5000] echo $(date '+%A, %B %d')";
          font_size = 22;
          halign = "center";
          valign = "center";
          position = "0, 200";
        }
      ];

      image = [
        {
          path = "$HOME/dotfiles/assets/face.jpg";
          size = 300;
          rounding = 8;
          border_color = theme.lavender;
          halign = "center";
          valign = "center";
        }
      ];

      input-field = lib.mkForce [
        {
          size = "300, 60";
          outline_thickness = 4;
          rounding = 8;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = theme.blue;
          inner_color = theme.surface0;
          font_color = theme.text;
          fade_on_empty = false;
          placeholder_text = "  $USER";
          hide_input = false;
          check_color = theme.blue;
          fail_color = theme.red;
          fail_text = "󱙱  $FAIL ($ATTEMPTS)";
          capslock_color = theme.yellow;
          position = "0, -205";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
