{
  lib,
  config,
  pkgs,
  pkgs-release,
  dotfilesPkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.hyprland.enable {
    programs.mpv.enable = true;

    home.packages = [
      dotfilesPkgs.ultrashell
      pkgs.pavucontrol
      pkgs.nautilus
      pkgs.libnotify
      pkgs.wtype
      pkgs.wl-clipboard

      # These track the compositor's IPC and protocol versions, so they come
      # from the release channel even though they live in the home layer.
      # See ADR-0007.
      pkgs-release.quickshell
      pkgs-release.hyprpaper
      pkgs-release.hyprshot
      pkgs-release.hyprpicker
      pkgs-release.hyprcursor
    ];
  };
}
