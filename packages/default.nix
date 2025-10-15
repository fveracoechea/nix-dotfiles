# Custom packages, that can be defined similarly to ones from nixpkgs
pkgs: {
  scripts = pkgs.callPackage ./scripts.nix {};
  tmuxPlugins = pkgs.callPackage ./tmux-plugins.nix {};
  dev-manager-desktop = pkgs.callPackage ./dev-manager-desktop.nix {};
  zeitfetch = pkgs.callPackage ./zeitfetch.nix {};
  mcpo = pkgs.callPackage ./mcpo.nix {};
  opencode = pkgs.callPackage ./opencode.nix {};
}
