{} @ args: {
  nixpkgs.overlays = [
    (import ./writeDeno.nix args)
  ];
}
