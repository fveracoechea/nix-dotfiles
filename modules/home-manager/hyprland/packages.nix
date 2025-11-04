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

    (writers.writeBashBin "set-screen-share-resolution" ''
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey-qhd}"
      hyprctl keyword monitor "${customUtils.monitors.dummy-4k-disabled}"
    '')

    (writers.writeBashBin "unset-screen-share-resolution" ''
      hyprctl keyword monitor "${customUtils.monitors.samsung-odyssey}"
      hyprctl keyword monitor "${customUtils.monitors.dummy-4k-disabled}"
    '')
  ];
}
