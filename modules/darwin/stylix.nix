{pkgs, ...}: let
  firaSans = {
    package = pkgs.fira-sans;
    name = "Fira Sans";
  };
  firaCode = {
    package = pkgs.fira-code-nerdfont;
    name = "FiraCode Nerd Font";
  };
in {
  stylix = {
    enable = true;
    autoEnable = true;
    image = ../../config/wallpapers/Cloudsday.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    opacity.terminal = 0.9;

    fonts = {
      serif = firaSans;
      sansSerif = firaSans;
      monospace = firaCode;
      emoji = firaCode;
    };
  };
}