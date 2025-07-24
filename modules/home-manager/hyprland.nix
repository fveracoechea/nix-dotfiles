{
  inputs,
  pkgs,
  lib,
  config,
  customUtils,
  ...
}: let
  apps = "fuzzel --cache ${config.home.homeDirectory}/.config/fuzzel/cache";
  terminal = "ghostty";
  browser = "google-chrome-stable";
  screenshot = "hyprshot -m output";
  workspaces = [1 2 3 4 5];
in {
  home.packages = with pkgs; [
    (writers.writeBashBin "set-screen-share-resolution" ''
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey-qhd}"
      hyprctl keyword monitor "${customUtils.monitors.dummy-4k-disabled}"
    '')

    (writers.writeBashBin "unset-screen-share-resolution" ''
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey}"
      hyprctl keyword monitor "${customUtils.monitors.dummy-4k-disabled}"
    '')
  ];

  programs.mpv.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = {
      env = [
        "BROWSER,${browser}"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_CURSOR_THEME,capitaine-cursors"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_CURSOR_SIZE,38"
      ];

      monitor = [
        customUtils.monitors.samsung-odyssey
        customUtils.monitors.dummy-4k-disabled
      ];

      debug = {
        # Claims support for all cm proto features
        # workaround for steam gamescope
        full_cm_proto = true;
      };

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
        "hyprpanel"
        "hyprdim --no-dim-when-only --persist --ignore-leaving-special --dialog-dim"
      ];

      general = {
        border_size = 3;
        gaps_in = 10;
        gaps_out = "10,20,20,20";
        layout = "dwindle";
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

      windowrule = let
        floatClass = class: "float,class:^(${class})$";
        floatTitle = title: "float, title:^(${title})$";
      in [
        "bordersize 0, fullscreen:1"
        "idleinhibit fullscreen, class:^(.*)$"

        (floatClass "file_progres")
        (floatClass "confirm")
        (floatClass "dialog")
        (floatClass "download")
        (floatClass "notification")
        (floatClass "error")
        (floatClass "confirmreset")
        (floatClass "imv")
        (floatClass "mpv")
        (floatClass "branchdialog")

        (floatTitle "Volume Control")
        (floatTitle "Bluetooth Devices")
        (floatTitle "Open File")
        (floatTitle "Save File")
        (floatTitle "Confirm to replace file")
        (floatTitle "File Operation Progress")
      ];

      bindm = [
        "SHIFT_ALT, mouse:272, movewindow"
        "SHIFT_ALT, mouse:273, resizewindow"
      ];

      workspace =
        map (i: "${toString i}, persistent:1") workspaces;

      bind = let
        binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
        bindExec = key: arg: "SUPER, ${key}, exec, ${arg}";
        mvfocus = binding "SUPER" "movefocus";
        resizeactive = binding "SUPER CTRL" "resizeactive";
        mvwindow = binding "SUPER ALT" "movewindow";
        workspaceBinding = binding "SUPER" "workspace";
        moveToWorkspaceBinding = binding "SUPER ALT" "movetoworkspace";
      in
        [
          (bindExec "B" browser)
          (bindExec "T" terminal)
          (bindExec "A" apps)
          (bindExec "S" screenshot)
          (bindExec "W" "hyprctl dispatch workspaceopt allfloat")
          (bindExec "P" "hyprctl dispatch workspaceopt allpseudo")

          "SUPER, F, togglefloating"
          "SUPER CTRL, P, pseudo"
          "SUPER ALT, F, fullscreen"
          "SUPER, Q, killactive"
          "SUPER CTRL, Q, exit"

          "SUPER CTRL, G, exec, steam-sunshine-do"
          "SUPER ALT, G, exec, steam-sunshine-undo"

          # move window focus
          (mvfocus "K" "u")
          (mvfocus "J" "d")
          (mvfocus "L" "r")
          (mvfocus "H" "l")
          # move active window
          (mvwindow "K" "u")
          (mvwindow "J" "d")
          (mvwindow "L" "r")
          (mvwindow "H" "l")
          # resize active window
          (resizeactive "K" "0 -100")
          (resizeactive "J" "0 100")
          (resizeactive "L" "100 0")
          (resizeactive "H" "-100 0")
        ]
        ++ (map (i: workspaceBinding (toString i) (toString i)) workspaces)
        ++ (map (i: moveToWorkspaceBinding (toString i) (toString i)) workspaces);
    };
  };
}
