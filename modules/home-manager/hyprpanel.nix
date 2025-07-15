{
  inputs,
  pkgs,
  system,
  ...
}: {
  programs.hyprpanel = let
    left = ["dashboard" "media" "systray" "clock" "notifications" "workspaces"];
    middle = ["windowtitle"];
    right = ["volume" "bluetooth" "network" "netstat" "cpu" "ram" "storage"];
  in {
    enable = true;
    systemd.enable = true;
    # overwrite.enable = true;
    package = inputs.hyprpanel.packages.${system}.default;

    # override = {
    #   theme.font.size = "16px";
    #   theme.font.name = "Fira Sans";
    #   theme.font.weight = 400;
    #
    #   theme.bar.opacity = 0;
    #   theme.bar.layer = "top";
    #   theme.bar.floating = true;
    #
    #   theme.bar.margin_top = "0.4em";
    #   theme.bar.margin_bottom = "0em";
    #   theme.bar.margin_sides = "0.8em";
    #   theme.bar.outer_spacing = "0em";
    #
    #   theme.bar.buttons.background_hover_opacity = 80;
    #   theme.bar.buttons.systray.spacing = "0.6em";
    #   theme.bar.buttons.radius = "1.4rem";
    #   theme.bar.buttons.padding_x = "0.8rem";
    #   theme.bar.buttons.spacing = "0.2em";
    #
    #   theme.tooltip.scaling = 80;
    #   theme.bar.menus.popover.scaling = 80;
    #   theme.bar.dashboard.scaling = 80;
    #
    #   theme.osd.location = "bottom";
    #   theme.osd.orientation = "horizontal";
    #   theme.osd.margins = "0px 0px 25px 0px";
    #   theme.osd.radius = "2em";
    # };

    settings = {
      scalingPriority = "hyprland";
      theme.name = "catppuccin_mocha";

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

      menus.clock = {
        time = {
          military = false;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = false;
      bar.clock.format = "%a %b %d %I:%M %p";

      layout = {
        "bar.layouts" = {
          "*" = {
            inherit left middle right;
          };
        };
      };
    };
  };
}
