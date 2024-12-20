{
  inputs,
  pkgs,
  ...
}: {
  # enables support for Bluetooth
  hardware.bluetooth.enable = true;
  # powers up the default Bluetooth controller on boot

  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  programs.ssh.startAgent = true;

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprdim
    hyprshot
    hyprpicker
    hyprcursor
    wl-clipboard
    libnotify
    pavucontrol
    networkmanagerapplet
    nautilus
    gnome-system-monitor
    gnome-calculator
    gnome-control-center
    gnome-weather
    gnome-clocks
  ];

  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
