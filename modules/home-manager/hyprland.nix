{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };

  programs.mpv.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = let
      apps = "fuzzel --cache ${config.home.homeDirectory}/.config/fuzzel/cache";
      terminal = "ghostty";
      browser = "google-chrome-stable";
      screenshot = "hyprshot -m output";
      monitor = "DP-2, highrr, auto, auto, cm, hdr, vrr, 1";
    in {
      env = [
        "BROWSER,${browser}"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "HYPRCURSOR_THEME,capitaine-cursors"
        "HYPRCURSOR_SIZE,38"
        "XCURSOR_THEME,capitaine-cursors"
        "XCURSOR_SIZE,38"
        "QT_CURSOR_THEME,capitaine-cursors"
        "QT_CURSOR_SIZE,38"
      ];

      inherit monitor;

      cursor = {
        enable_hyprcursor = false;
      };

      experimental = {
        xx_color_management_v4 = true;
      };

      misc = {
        vrr = 1;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
      };

      exec-once = [
        "sleep 2 && hyprpanel"
        "hyprdim --no-dim-when-only --persist --ignore-leaving-special --dialog-dim"
      ];

      general = {
        border_size = 3;
        gaps_in = 8;
        gaps_out = "14 20 20 20";
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

      windowrulev2 = let
        floatClass = class: "float,class:^(${class})$";
        floatTitle = title: "float, title:^(${title})$";
      in [
        "bordersize 0, fullscreen:1"
        "minsize 1000 650, floating:1"
        "opacity 0.9 0.9 1.0, title:(.*)$"
        "opacity 1.0, class:(google-chrome)"
        "opacity 1.0, class:(fuzzel)"
        "opacity 1.0, class:(com.mitchellh.ghostty)"
        "center, floating:1"

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

        (floatTitle "org.gnome.Settings")
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

      bind = let
        binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
        bindExec = key: arg: "SUPER, ${key}, exec, ${arg}";
        mvfocus = binding "SUPER" "movefocus";
        resizeactive = binding "SUPER CTRL" "resizeactive";
        mvwindow = binding "SUPER ALT" "movewindow";
        ws = binding "SUPER" "workspace";
        mvtows = binding "SUPER ALT" "movetoworkspace";
        workspaces = [1 2 3 4 5];
      in
        [
          (bindExec "B" browser)
          (bindExec "T" terminal)
          (bindExec "A" apps)
          (bindExec "N" "fuzzel-notifications")
          (bindExec "S" screenshot)
          (bindExec "W" "hyprctl dispatch workspaceopt allfloat")

          "SUPER, F, togglefloating"
          "SUPER, P, pseudo"
          "SUPER ALT, F, fullscreen"
          "SUPER, Q, killactive"
          "SUPER CTRL, Q, exit"

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
        ++ (map (i: ws (toString i) (toString i)) workspaces)
        ++ (map (i: mvtows (toString i) (toString i)) workspaces);
    };
  };
}
