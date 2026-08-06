{inputs, ...}: {
  # Installs into environment.systemPackages so nix-darwin links Spotify.app
  # into /Applications/Nix Apps where Spotlight and Launchpad can find it.
  imports = [
    inputs.spicetify-nix.darwinModules.default
    ../core/spicetify.nix
  ];
}
