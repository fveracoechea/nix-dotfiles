{
  inputs,
  lib,
  customUtils,
  system,
  ...
}: let
  persistentWorkspaces = [1 2 3 4 5];
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;

    settings = {
      monitor = [
        customUtils.monitors.samsung-odyssey
        customUtils.monitors.dummy-4k-disabled
      ];

      cursor = {
        enable_hyprcursor = false;
      };

      experimental = {
        xx_color_management_v4 = true;
      };

      misc = {
        vrr = 2;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
      };

      exec-once = [
        "ultrashell"
        # "hyprpanel"
        "hyprdim --no-dim-when-only --persist --ignore-leaving-special --dialog-dim"
      ];

      general = {
        border_size = 3;
        gaps_in = 10;
        gaps_out = "10,20,20,20";
      };

      dwindle = {
        # Avoid overly wide single-window layouts on wide screens
        single_window_aspect_ratio = "1 1";
      };

      decoration = lib.mkForce {
        rounding = 8;
        blur.enabled = true;
      };

      master = {
        allow_small_split = true;
        mfact = 0.32;
        new_on_top = false;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      workspace =
        map (i: "${toString i}, persistent:true") persistentWorkspaces;
    };
  };
}
