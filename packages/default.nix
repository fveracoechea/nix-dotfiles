# Custom packages, that can be defined similarly to ones from nixpkgs
pkgs: let
  nodeEnv = pkgs.callPackage ../node-env.nix {
    libtool =
      if pkgs.stdenv.isDarwin
      then pkgs.darwin.cctools
      else null;
  };
in {
  scripts = pkgs.callPackage ./scripts.nix {};
  nodePackages = pkgs.callPackage ./node-packages.nix {inherit nodeEnv;};
  tmuxPlugins = pkgs.callPackage ./tmux-plugins.nix {};
  dev-manager-desktop = pkgs.callPackage ./dev-manager-desktop.nix {};
}
