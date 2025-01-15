{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.hyprpanel.overlay

    (import ./helpers.nix)

    # Brings custom packages from the 'packages' directory
    (final: prev: import ../packages final)
  ];
}
