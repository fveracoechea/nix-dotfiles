{pkgs, ...}: let
  monitors = import ../../utils/monitors.nix;
in {
  home.packages = with pkgs; [
    (writers.writeBashBin "steam-sunshine-do" ''
      hyprctl keyword monitor "${monitors.dummy-4k}"
      hyprctl keyword monitor "${monitors.samsung-odyssey-disabled}"
    '')

    (writers.writeBashBin "steam-sunshine-undo" ''
      hyprctl keyword monitor "${monitors.samsung-odyssey}"
      hyprctl keyword monitor "${monitors.dummy-4k-disabled}"
    '')

    (writers.writeBashBin "steam-big-picture" ''
      sleep 2
      DXVK_HDR=1 PROTON_ENABLE_HDR=1 gamescope -- setsid steam -gamepadui -tenfoot &> ~/dotfiles/steam-logs.txt
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
