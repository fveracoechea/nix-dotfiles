{...}: {
  programs.hyprpanel = let
    left = ["dashboard" "media" "systray" "clock" "notifications" "workspaces"];
    middle = ["windowtitle"];
    right = ["volume" "bluetooth" "network" "cpu" "cputemp" "ram" "storage" "hypridle"];
  in {
    enable = false;
    systemd.enable = true;

    settings = {
      scalingPriority = "hyprland";

      notifications.position = "bottom";

      bar.launcher.autoDetectIcon = true;
      bar.notifications.show_total = true;
      bar.notifications.hideCountWhenZero = true;

      # bar.workspaces.show_icons = false;
      # bar.workspaces.show_numbered = true;
      bar.workspaces.showAllActive = true;
      # bar.workspaces.numbered_active_indicator = "underline";
      # bar.customModules.netstat.dynamicIcon = false;
      bar.customModules.netstat.labelType = "in";
      # bar.customModules.netstat.icon = "";
      bar.customModules.netstat.rateUnit = "auto";

      bar.clock.format = "%a %b %d %I:%M %p";
      bar.layouts = {
        "*" = {
          inherit left middle right;
        };
      };

      menus.clock = {
        time = {
          military = false;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = false;

      theme = {
        name = "catppuccin_mocha";
        bar.opacity = 0;
        bar.floating = true;
        bar.layer = "top";

        font.size = "17px";
        font.name = "Fira Sans";
        font.weight = 400;

        bar.margin_top = "0.4em";
        bar.margin_sides = "0px";
        bar.margin_bottom = "0px";
        bar.outer_spacing = "0.85em";

        bar.buttons.background_hover_opacity = 80;
        bar.buttons.systray.spacing = "0.6em";
        bar.buttons.radius = "1em";
        bar.buttons.padding_x = "0.8rem";
        bar.buttons.spacing = "0.2em";

        tooltip.scaling = 80;
        bar.menus.popover.scaling = 80;
        bar.dashboard.scaling = 80;

        osd.location = "bottom";
        osd.orientation = "horizontal";
        osd.margins = "0px 0px 25px 0px";
        osd.radius = "2em";
      };
    };
  };
}
