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
          # hibernate after 15mins
          timeout = 900;
          on-timeout = "systemctl hibernate";
        }
      ];
    };
  };
}
