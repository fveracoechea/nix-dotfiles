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
    package = pkgs.nerd-fonts.fira-code;
    name = "FiraCode Nerd Font";
  };
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = true;
    image = ../../wallpapers/islands-ultrawide.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    cursor = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 38;
    };

    opacity.terminal = 0.9;

    fonts = {
      serif = firaSans;
      sansSerif = firaSans;
      monospace = firaCode;
      emoji = firaCode;

      sizes = {
        applications = 12;
        desktop = 12;
        popups = 12;
        terminal = 12.5;
      };
    };

    targets.grub.enable = true;
    targets.grub.useImage = true;
  };
}
