{
  pkgs,
  inputs,
}: {
  dev-manager-desktop = pkgs.callPackage ./dev-manager-desktop.nix {};
  stylelint-language-server = pkgs.callPackage ./stylelint-language-server.nix {};

  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  herdr = inputs.herdr.packages.${pkgs.system}.herdr;
  hyprland-portal = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  tmux-powerkit = inputs.tmux-powerkit.packages.${pkgs.system}.default;
  ultrashell = inputs.ultrashell.packages.${pkgs.system}.default;
  hunk = inputs.hunk.packages.${pkgs.system}.default;
}
