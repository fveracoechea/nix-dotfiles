{
  pkgs,
  customUtils,
  ...
}: {
  home.packages = [
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
        auto-detach = "true";
        # detached = ["sunshine-to-steamos"];
        # prep-cmd = [
        #   {
        #     do = "sunshine-to-steamos";
        #     undo = "sunshine-to-hyprland";
        #   }
        # ];
      }
    ];
  };
}
