{lib, ...}: {
  programs.hyprlock = let
    theme = {
      blue = "rgb(89b4fa)";
      lavender = "rgb(b4befe)";
      surface0 = "rgb(313244)";
      surface1 = "rgb(45475a)";
      red = "rgb(f38ba8)";
      yellow = "rgb(f9e2af)";
      text = "rgb(cdd6f4)";
    };
  in {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = lib.mkForce [
        {
          path = "$HOME/dotfiles/wallpapers/islands-ultrawide.png";
          blur_passes = 2;
          blur_size = 5;
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
          path = "$HOME/.face";
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
