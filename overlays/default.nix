{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.hyprpanel.overlay

    # My scripts
    (final: prev: import ./scripts final)

    # Brings custom packages from the 'packages' directory
    (final: prev: import ../packages final)
  ];
}
