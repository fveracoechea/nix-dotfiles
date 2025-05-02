{pkgs, ...}: {
  home.packages = with pkgs; [
    (writers.writeBashBin "steam-sunshine-do"
      # bash
      ''
        hyprctl keyword monitor "HDMI-A-1, highrr, auto, auto, vrr, 3, cm, hdr"
        hyprctl keyword monitor "DP-1, disable"
      '')
    (writers.writeBashBin "steam-sunshine-undo"
      # bash
      ''
        hyprctl keyword monitor "DP-1, 5120x1440@119.98Hz, auto, auto, vrr, 3, cm, auto"
        hyprctl keyword monitor "HDMI-A-1, disable"
      '')
  ];

  xdg.configFile."sunshine/apps.json".text = builtins.toJSON {
    env = {
      "PATH" = "$(PATH):$(HOME)/.local/bin";
    };
    apps = [
      {
        name = "Steam 4K";
        image-path = "steam.png";
        detached = ["steam -gamepadui -pipewire-dmabuf -tenfoot"];
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
