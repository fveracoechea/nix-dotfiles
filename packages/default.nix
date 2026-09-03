# The channel each package is built from is chosen here, per entry, so every
# consumer keeps reading `dotfilesPkgs.<name>` and no call site has to know.
#
#   pkgs        latest channel: apps, CLI, and tooling
#   pkgs-stable release channel: system packages and the compositor
{
  pkgs,
  pkgs-stable,
  inputs,
}: {
  dev-manager-desktop = pkgs.callPackage ./dev-manager-desktop.nix {};
  stylelint-language-server = pkgs.callPackage ./stylelint-language-server.nix {};

  herdr = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
  tmux-powerkit = inputs.tmux-powerkit.packages.${pkgs.stdenv.hostPlatform.system}.default;
  ultrashell = inputs.ultrashell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  hunk = inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # The compositor and its portal are system packages, and `inputs.hyprland`
  # follows `nixpkgs-stable` to match.
  hyprland = inputs.hyprland.packages.${pkgs-stable.stdenv.hostPlatform.system}.hyprland;
  hyprland-portal = inputs.hyprland.packages.${pkgs-stable.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
}
