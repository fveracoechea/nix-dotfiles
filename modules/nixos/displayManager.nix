{
  pkgs,
  customUtils,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cmatrix
    terminus_font
  ];

  console = let
    theme = customUtils.catppuccin;
  in {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u24n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "us";
    colors = map (color: (lib.substring 1 6 (lib.strings.toLower color))) [
      theme.base
      theme.red
      theme.green
      theme.yellow
      theme.blue
      theme.pink
      theme.teal
      theme.subtext1

      theme.surface2
      theme.red
      theme.green
      theme.yellow
      theme.blue
      theme.pink
      theme.teal
      theme.subtext0
    ];
  };

  services.displayManager = {
    ly.enable = true;
    ly.settings = {
      animate = true;
      animation = "matrix";
    };
  };
}
