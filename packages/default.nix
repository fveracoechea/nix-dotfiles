# Custom packages, that can be defined similarly to ones from nixpkgs
pkgs: {
  dev-manager-desktop = pkgs.callPackage ./dev-manager-desktop.nix {};
}
