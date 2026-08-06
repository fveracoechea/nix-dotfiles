{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ../core/spicetify.nix
  ];

  config = lib.mkIf config.dotfiles.spotify.enable {
    programs.cava.enable = true;
  };
}
