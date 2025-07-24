{pkgs, utils, ...}: {
  home.packages = with pkgs; [
    (writers.writeBashBin "steam-sunshine-do" ''
      hyprctl keyword monitor "${utils.monitors.dummy-4k}"
      hyprctl keyword monitor "${utils.monitors.samsung-odyssey-disabled}"
    '')

    (writers.writeBashBin "steam-sunshine-undo" ''
      steam -shutdown
      sleep 2
      hyprctl keyword monitor "${utils.monitors.samsung-odyssey}"
      hyprctl keyword monitor "${utils.monitors.dummy-4k-disabled}"
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
