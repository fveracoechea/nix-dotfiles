{...}: let
  monitor = "DP-1";
  wallpapersDir = ../../../assets/wallpapers;
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      # preload = wallpapers;
      wallpaper = [
        {
          inherit monitor;
          path = toString wallpapersDir;
          timeout = 3;
        }
      ];
    };
  };
}
