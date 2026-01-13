{...}: {
  # stylix.targets.hyprpaper.enable = lib.mkForce false;

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = "DP-1";
          path = "~/dotfiles/wallpapers/islands-ultrawide.png";
        }
      ];
    };
  };
}
