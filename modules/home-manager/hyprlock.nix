{lib, ...}: {
  programs.hyprlock = let
    theme = {
      blue = "rgb(89b4fa)";
      surface0 = "rgb(313244)";
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
          path = "$HOME/dotfiles/wallpapers/dark-forrest-ultrawide.png";
          blur_passes = 1;
          blur_size = 4;
        }
      ];

      label = [
        {
          text = "cmd[update:5000] echo $(date '+%I:%M %p')";
          font_size = 44;
          halign = "center";
          valign = "top";
          position = "0, -150";
        }
        {
          text = "cmd[update:5000] echo $(date '+%A %B %d')";
          font_size = 22;
          halign = "center";
          valign = "top";
          position = "0, -225";
        }
      ];

      image = [
        {
          path = "$HOME/.face";
          size = 225;
          border_color = theme.blue;
          halign = "center";
          valign = "center";
          position = "0, 75";
        }
      ];

      input-field = lib.mkForce [
        {
          size = "400, 60";
          outline_thickness = 4;
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
          position = "0, -100";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
