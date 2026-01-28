{config, ...}: let
  monitor = "DP-1";
  wallpaper = "${config.home.homeDirectory}/dotfiles/assets/wallpapers/yellow-mountains.png";
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [wallpaper];
      wallpaper = [
        {
          inherit monitor;
          path = wallpaper;
        }
      ];
    };
  };
}
