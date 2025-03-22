{...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = [
        {
          path = ../../wallpapers/dark-forrest-ultrawide.png;
          blur_passes = 1;
          blur_size = 4;
        }
      ];

      label = [
        {
          text = "cmd[update:5000] echo $(date '+%A %B %d - %I:%M %p')";
          font_size = 40;
          halign = "center";
          valign = "top";
        }
      ];

      image = [
        {
          path = ../../wallpapers/face.jpg;
          size = 100;
          border_color = "$accent";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
          hide_input = false;
          check_color = "$accent";
          fail_color = "$red";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "$yellow";
          position = "0, -47";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
