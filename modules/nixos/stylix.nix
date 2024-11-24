{
  pkgs,
  inputs,
  ...
}: let
  firaSans = {
    package = pkgs.fira-sans;
    name = "Fira Sans";
  };
  firaCode = {
    package = pkgs.fira-code-nerdfont;
    name = "FiraCode Nerd Font";
  };
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = true;
    image = ../../config/wallpapers/mountain-untrawide.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    cursor = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 38;
    };

    fonts = {
      serif = firaSans;
      sansSerif = firaSans;
      monospace = firaCode;
      emoji = firaCode;
    };

    targets.grub.enable = true;
    targets.grub.useImage = true;
  };
}
