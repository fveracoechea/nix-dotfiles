{
  pkgs,
  inputs,
}: let
  # nixpkgs ships glaze 8.x, but hyprland's CMake requires glaze >=7 <8 and
  # otherwise falls back to FetchContent, which fails in the Nix sandbox.
  glaze-hyprland =
    (pkgs.glaze.override {
      enableSSL = false;
      enableInterop = false;
    })
    .overrideAttrs (finalAttrs: {
      version = "7.9.1";
      src = pkgs.fetchFromGitHub {
        owner = "stephenberry";
        repo = "glaze";
        tag = "v${finalAttrs.version}";
        hash = "sha256-NRRq5MGF2f5PW0teYnq58ELzson+U6KHVPaY6r30KLA=";
      };
    });
in {
  dev-manager-desktop = pkgs.callPackage ./dev-manager-desktop.nix {};
  stylelint-language-server = pkgs.callPackage ./stylelint-language-server.nix {};

  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland.override {
    inherit glaze-hyprland;
  };
  herdr = inputs.herdr.packages.${pkgs.system}.herdr;
  hyprland-portal = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  tmux-powerkit = inputs.tmux-powerkit.packages.${pkgs.system}.default;
  ultrashell = inputs.ultrashell.packages.${pkgs.system}.default;
  hunk = inputs.hunk.packages.${pkgs.system}.default;
}
