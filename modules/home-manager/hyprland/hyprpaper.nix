{...}: let
  monitor = "DP-1";
  wallpaper = builtins.toString ../../../wallpapers/islands-ultrawide.png;
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [wallpaper];
      wallpaper = ["${monitor},${wallpaper}"];
    };
  };
}
