{pkgs, ...}: let
  darwinOrElse = darwin: nixos:
    if pkgs.system == "aarch64-darwin"
    then darwin
    else nixos;
in {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      background-blur-radius = 18;
      window-padding-color = "background";
      window-padding-x = 4;
      window-padding-y = 4;
      window-decoration = darwinOrElse true false;
      shell-integration = "zsh";
    };
  };
}
