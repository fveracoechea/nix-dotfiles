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
    "-O HDMI-A-1" # Output display

    # "--xwayland-count 2"
    # "--force-grab-cursor"
    # "--hdr-debug-force-output"
  ];

  argsString = builtins.concatStringsSep " " gamescopeArgs;

  testCmd = pkgs.writers.writeBashBin "test-sunshine-steam" ''
    sunshine-to-steamos
    sleep 5
    sunshine-to-hyprland
  '';

  toSteamCmd = pkgs.writers.writeBashBin "sunshine-to-steamos" ''
    set -e
    if pgrep -x gamescope >/dev/null; then
      echo "Gamescope already running"
      exit 0
    fi

    hyprctl keyword monitor "${customUtils.monitors.dummy-4k}"
    hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey-disabled}"
    sleep 1

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

    export DXVK_HDR=1
    export ENABLE_HDR_WSI=1
    setsid gamescope ${argsString} -- steam -tenfoot >> ~/dotfiles/steam-logs.txt 2>&1 &
    disown
  '';

  toHyprCmd = pkgs.writers.writeBashBin "sunshine-to-hyprland" ''
    # Restore Hyprland session from Gamescope/Steam
    if pgrep -x Hyprland >/dev/null; then
      echo "Hyprland already running"
      exit 0
    fi

    # Stop Gamescope cleanly if running
    if pgrep -x gamescope >/dev/null; then
      pkill -TERM gamescope || true
      for i in $(seq 1 50); do
        pgrep -x gamescope >/dev/null || break
        sleep 0.1
      done
      pkill -KILL gamescope || true
    fi

    # Clean up any lingering UWSM/session units to avoid "already active"
    if command -v systemctl >/dev/null; then
      systemctl --user stop wayland-wm@Hyprland.service wayland-session@Hyprland.target wayland-session-pre@Hyprland.target graphical-session.target 2>/dev/null || true
    fi

    logFile=~/dotfiles/hyprland-logs.txt

    if command -v uwsm >/dev/null; then
      uwsm reset >/dev/null 2>&1 || true
      uwsm start hyprland-uwsm.desktop >> "$logFile" 2>&1 &
    else
      Hyprland >> "$logFile" 2>&1 &
    fi

    # Wait for Hyprland to start
    for i in $(seq 1 60); do
      if pgrep -x Hyprland >/dev/null; then
        break
      fi
      sleep 0.25
    done

    # Restore monitor setup
    hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey}"
    hyprctl keyword monitor "${customUtils.monitors.dummy-4k-disabled}"
  '';
in {
  home.packages = [
    testCmd
    toHyprCmd
    toSteamCmd

    (pkgs.writers.writeBashBin "desktop-sunshine-do" ''
      hyprctl keyword monitor "${customUtils.monitors.dummy-4k}"
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey-disabled}"
    '')

    (pkgs.writers.writeBashBin "desktop-sunshine-undo" ''
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey}"
      hyprctl keyword monitor "${customUtils.monitors.dummy-4k-disabled}"
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
