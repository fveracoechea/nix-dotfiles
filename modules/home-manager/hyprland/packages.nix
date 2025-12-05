{
  pkgs,
  system,
  inputs,
  customUtils,
  ...
}: {
  programs.mpv.enable = true;

  home.packages = with pkgs; [
    inputs.ultrashell.packages.${system}.default

    hyprdim
    hyprshot
    hyprpicker
    hyprcursor

    (writers.writeBashBin "set-screen-share-resolution" ''
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey-qhd}"
    '')

    (writers.writeBashBin "unset-screen-share-resolution" ''
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey}"
    '')
  ];
}
