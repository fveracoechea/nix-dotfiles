{...}: {
  stylix.targets.hyprpaper.enable = false;

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = "*";
          path = ../../../wallpapers/islands-ultrawide.png;
        }
      ];
    };
  };
}
