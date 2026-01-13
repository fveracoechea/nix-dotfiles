{...}: {
  # stylix.targets.hyprpaper.enable = lib.mkForce false;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/dotfiles/wallpapers/islands-ultrawide.png"
      ];
      wallpaper = [
        "DP-1,~/dotfiles/wallpapers/islands-ultrawide.png"
      ];
    };
  };
}
