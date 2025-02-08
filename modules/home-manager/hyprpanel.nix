{inputs, ...}: let
  cpt = import ../../utils/catppuccin.nix;
in {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  programs.hyprpanel = {
    enable = true;
    overwrite.enable = true;

    theme = "catppuccin_mocha";

    override = {
      theme.bar.opacity = 35;
      theme.bar.background = cpt.surface2;
      theme.bar.border_radius = "1.4em";

      theme.bar.buttons.windowtitle.text = cpt.text;
      theme.bar.buttons.windowtitle.icon = cpt.blue;
      theme.bar.buttons.clock.text = cpt.text;
      theme.bar.buttons.media.text = cpt.text;
      theme.bar.buttons.network.text = cpt.text;
      theme.bar.buttons.volume.text = cpt.text;
      theme.bar.buttons.bluetooth.text = cpt.text;
      theme.bar.buttons.notifications.text = cpt.text;
      theme.bar.buttons.dashboard.icon = cpt.blue;

      theme.bar.buttons.workspaces.active = cpt.blue;
      theme.bar.buttons.workspaces.available = cpt.overlay2;
      theme.bar.buttons.workspaces.occupied = cpt.overlay2;
      theme.bar.buttons.workspaces.hover = cpt.lavender;

      theme.bar.buttons.background_hover_opacity = 80;

      theme.bar.margin_top = "1em";
      theme.bar.margin_sides = "1em";
      theme.bar.buttons.spacing = "0.4em";
      theme.bar.outer_spacing = "0.4em";

      theme.bar.buttons.enableBorders = false;
      theme.bar.buttons.radius = "1.4em";
      theme.bar.buttons.padding_x = "0.8em";
      theme.bar.buttons.padding_y = "0.15em";
      theme.font.name = "Fira Code Nerd Font";
      theme.font.size = "16px";

      theme.tooltip.scaling = 75;
      theme.bar.menus.popover.scaling = 80;

      theme.osd.location = "bottom";
      theme.osd.orientation = "horizontal";
      theme.osd.margins = "0px 0px 25px 0px";
      theme.osd.radius = "2em";
    };

    layout = {
      "bar.layouts" = {
        "*" = {
          left = ["dashboard" "media" "systray" "workspaces"];
          middle = ["windowtitle"];
          right = ["clock" "volume" "network" "bluetooth" "notifications" "power"];
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

      menus.clock = {
        time = {
          military = false;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = false;
      bar.clock.format = "%I:%M %p - %A %b %d";
    };
  };
}
