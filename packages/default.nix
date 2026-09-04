{
  pkgs,
  inputs,
}: let
  # Hyprland 0.55.4, held back from a pinned nixpkgs. See flake.nix.
  hyprlandPkgs = import inputs.nixpkgs-hyprland {inherit (pkgs.stdenv.hostPlatform) system;};
in {
  dev-manager-desktop = pkgs.callPackage ./dev-manager-desktop.nix {};
  stylelint-language-server = pkgs.callPackage ./stylelint-language-server.nix {};

  hyprland = hyprlandPkgs.hyprland;
  herdr = inputs.herdr.packages.${pkgs.system}.herdr;
  hyprland-portal = hyprlandPkgs.xdg-desktop-portal-hyprland;
  tmux-powerkit = inputs.tmux-powerkit.packages.${pkgs.system}.default;
  ultrashell = inputs.ultrashell.packages.${pkgs.system}.default;
  hunk = inputs.hunk.packages.${pkgs.system}.default;
}
