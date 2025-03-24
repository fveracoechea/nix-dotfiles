{inputs, ...}: let
  cpt = import ../../utils/catppuccin.nix;
in {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  programs.hyprpanel = {
    enable = true;
    overwrite.enable = true;

    theme = "catppuccin_mocha";

    override = {
      theme.font.size = "15px";
      theme.font.name = "Fira Code Nerd Font";
      theme.font.weight = 500;
      theme.bar.background = cpt.surface1;

      theme.bar.opacity = 80;
      theme.bar.layer = "top";
      theme.bar.floating = true;

      theme.bar.margin_top = "0.8em";
      theme.bar.margin_sides = "1em";
      theme.bar.outer_spacing = "0.4em";

      theme.bar.buttons.background_hover_opacity = 80;

      theme.bar.buttons.style = "default";
      theme.bar.buttons.borderSize = "1px";

      theme.bar.buttons.systray.spacing = "0.6em";

      theme.bar.border_radius = "1.4rem";
      theme.bar.buttons.radius = "1.4rem";
      theme.bar.buttons.padding_y = "0.2rem";
      theme.bar.buttons.padding_x = "0.8rem";
      theme.bar.buttons.spacing = "0.3em";
      theme.bar.buttons.y_margins = "0.5em";

      theme.tooltip.scaling = 75;
      theme.bar.menus.popover.scaling = 80;
      theme.bar.dashboard.scaling = 80;

      theme.osd.location = "bottom";
      theme.osd.orientation = "horizontal";
      theme.osd.margins = "0px 0px 25px 0px";
      theme.osd.radius = "2em";
    };

    layout = {
      "bar.layouts" = {
        "*" = {
          left = ["dashboard" "media" "cava" "systray" "clock" "workspaces"];
          middle = ["windowtitle"];
          right = ["volume" "bluetooth" "network" "netstat" "cpu" "ram" "storage" "notifications"];
        };
      };
    };

    settings = {
      scalingPriority = "hyprland";
      bar.launcher.autoDetectIcon = true;

      notifications.position = "bottom";
      bar.notifications.show_total = true;
      bar.notifications.hideCountWhenZero = true;

      bar.workspaces.show_icons = false;
      bar.workspaces.show_numbered = true;
      bar.workspaces.showAllActive = true;
      bar.workspaces.numbered_active_indicator = "underline";
      bar.customModules.netstat.dynamicIcon = false;
      bar.customModules.netstat.labelType = "in";
      bar.customModules.netstat.icon = "";
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
    };
  };
}
