{
  lib,
  config,
  dotfilesPkgs,
  ...
}: {
  options.dotfiles.hyprland.enable = lib.mkEnableOption "Hyprland compositor";

  config = lib.mkIf config.dotfiles.hyprland.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      package = dotfilesPkgs.hyprland;
      portalPackage = dotfilesPkgs.hyprland-portal;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
