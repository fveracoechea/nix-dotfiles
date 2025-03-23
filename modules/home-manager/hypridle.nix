{...}: {
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          # lock screen after 5mins
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          # suspend after 30mins
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
