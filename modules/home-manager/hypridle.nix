{...}: {
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        before_sleep_cmd = "hyprctl dispatch dpms off";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          # turn off monitor after 5mins
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          # lock screen after 10mins
          timeout = 600;
          on-timeout = "hyprlock";
        }
        {
          # hibernate after 15mins
          timeout = 900;
          on-timeout = "systemctl hibernate";
        }
      ];
    };
  };
}
