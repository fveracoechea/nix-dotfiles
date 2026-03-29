# Custom packages, that can be defined similarly to ones from nixpkgs
pkgs: {
  dev-manager-desktop = pkgs.callPackage ./dev-manager-desktop.nix {};
  zeitfetch = pkgs.callPackage ./zeitfetch.nix {};
  mcpo = pkgs.callPackage ./mcpo.nix {};
}
