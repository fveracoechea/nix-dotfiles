{
  pkgs,
  inputs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages."${pkgs.system}".default;
    enableZshIntegration = true;
    settings = {
      background-blur-radius = 18;
      window-padding-color = "background";
      window-padding-x = 4;
      window-padding-y = 4;
      window-decoration = "auto";
      shell-integration = "zsh";
      font-family-bold = "FiraCode Nerd Font Bold";
      font-family-italic = "FiraCode Nerd Font Italic";
      font-family-bold-italic = "FiraCode Nerd Font Italic Bold";
    };
  };
}
