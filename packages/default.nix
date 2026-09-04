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

  # The compositor and its portal are system packages, so they come from the
  # release channel. Not from `hyprwm/Hyprland`: that flake tracks main, which
  # is 0.56, and 0.56 dropped hyprlang and reads only `hyprland.lua`. The
  # release holds 0.55.4, the last hyprlang version, and ships it prebuilt in
  # cache.nixos.org. Porting the config to lua is what unblocks 26.11.
  hyprland = pkgs-stable.hyprland;
  hyprland-portal = pkgs-stable.xdg-desktop-portal-hyprland;
}
