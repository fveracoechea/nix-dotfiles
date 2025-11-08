{
  pkgs,
  customUtils,
  ...
}: let
  gamescopeArgs = [
    "-f" # Fullscreen
    "-e" # Steam integration with Gamescope
    "--adaptive-sync" # VRR support
    "--hdr-enabled" # HDR
    "--rt" # Real time scheduling
    "-W 3840"
    "-H 2160"
    "-r 120" # Refresh rate
    "-O HDMI-A-2" # Output display

    # "--xwayland-count 2"
    # "--force-grab-cursor"
    # "--hdr-debug-force-output"
  ];

  argsString = builtins.concatStringsSep " " gamescopeArgs;

  toSteamCmd = pkgs.writers.writeBashBin "sunshine-to-steamos" ''
    set -e
    if pgrep -x gamescope >/dev/null; then
      echo "Gamescope already running"
      exit 0
    fi

    if pgrep -x Hyprland >/dev/null; then
      if command -v hyprctl >/dev/null; then
        hyprctl dispatch exit || true
      else
        pkill -TERM Hyprland || true
      fi
      for i in $(seq 1 50); do
        pgrep -x Hyprland >/dev/null || break
        sleep 0.1
      done
    fi

    if command -v notify-send >/dev/null; then
      notify-send "Session" "Launching SteamOS (gamescope)" -t 2000
    fi

    echo "Starting Gamescope + Steam (${argsString})" > ~/dotfiles/steam-logs.txt
    # Detach gamescope session; keep logging
    setsid gamescope ${argsString} -- steam -tenfoot >> ~/dotfiles/steam-logs.txt 2>&1 &
    disown
    echo "Launch command issued; check ~/dotfiles/steam-logs.txt for runtime output" >> ~/dotfiles/steam-logs.txt
  '';

  toHyprCmd = pkgs.writers.writeBashBin "sunshine-to-hyprland" ''
    set -e
    if pgrep -x Hyprland >/dev/null; then
      echo "Hyprland already running"
      exit 0
    fi

    if pgrep -x gamescope >/dev/null; then
      pkill -TERM gamescope || true
      for i in $(seq 1 50); do
        pgrep -x gamescope >/dev/null || break
        sleep 0.1
      done
      pkill -KILL gamescope || true
    fi

    if command -v notify-send >/dev/null; then
      notify-send "Session" "Launching Hyprland" -t 1500
    fi

    if command -v uwsm >/dev/null; then
      exec uwsm start hyprland-uwsm.desktop
    else
      exec Hyprland
    fi
  '';
in {
  home.packages = with pkgs; [
    toHyprCmd
    toSteamCmd

    (writers.writeBashBin "desktop-sunshine-do" ''
      hyprctl keyword monitor "${customUtils.monitors.dummy-4k}"
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey-disabled}"
    '')

    (writers.writeBashBin "desktop-sunshine-undo" ''
      steam -shutdown
      sleep 2
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey}"
      hyprctl keyword monitor "${customUtils.monitors.dummy-4k-disabled}"
    '')

    (writers.writeBashBin "steam-big-picture" ''
      sleep 2

      # # Allows Steam to handle multiple XWayland instances, important for Gamescope integration
      # export STEAM_MULTIPLE_XWAYLANDS=1
      # Enables HDR support within DXVK (Direct3D to Vulkan translation layer).
      export DXVK_HDR=1
      # Activates the Vulkan Wayland HDR WSI layer.
      export ENABLE_HDR_WSI=1

      setsid steam -gamepadui -steamos3 &> ~/dotfiles/steam-logs.txt
    '')
  ];

  xdg.configFile."sunshine/apps.json".text = builtins.toJSON {
    env = {
      "PATH" = "$(PATH):$(HOME)/.local/bin";
    };
    apps = [
      {
        name = "Desktop";
        image-path = "desktop.png";
        prep-cmd = [
          {
            do = "desktop-sunshine-do";
            undo = "desktop-sunshine-undo";
          }
        ];
      }
      {
        name = "Steam Big Picture";
        image-path = "steam.png";
        # auto-detach = "true";
        # detached = ["sunshine-to-steamos"];
        prep-cmd = [
          {
            do = "sunshine-to-steamos";
            undo = "sunshine-to-hyprland";
          }
        ];
      }
    ];
  };
}
