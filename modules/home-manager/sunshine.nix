{pkgs, ...}: {
  home.packages = with pkgs; [
    (writers.writeBashBin "steam-sunshine-do"
      # bash
      ''
        hyprctl keyword monitor "HDMI-A-1, 3840x2160@120.00Hz, auto, auto, vrr, 1, cm, hdr"
        hyprctl keyword monitor "DP-1, disable"
      '')
    (writers.writeBashBin "steam-sunshine-undo"
      # bash
      ''
        hyprctl keyword monitor "DP-1, 5120x1440@119.98Hz, auto, auto, vrr, 3, cm, auto"
        hyprctl keyword monitor "HDMI-A-1, disable"
      '')
    (writers.writeBashBin "steam-big-picture"
      # bash
      ''
        sleep 2
        gamescope -- setsid steam -gamepadui -tenfoot &> ~/dotfiles/steam-logs.txt
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
            do = "steam-sunshine-do";
            undo = "steam-sunshine-undo";
          }
        ];
      }
      {
        name = "Steam Big Picture";
        image-path = "steam.png";
        auto-detach = "true";
        detached = ["steam-big-picture"];
        prep-cmd = [
          {
            do = "steam-sunshine-do";
            undo = "steam-sunshine-undo";
          }
        ];
      }
    ];
  };
}
