{...}: {
  stylix.targets.ghostty.enable = false;

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "Catppuccin Mocha";
      shell-integration = "zsh";

      background-opacity = 0.88;
      background-blur = true;

      window-padding-color = "background";
      window-padding-x = 6;
      window-padding-y = 6;
      window-decoration = "auto";

      font-family-bold = "FiraCode Nerd Font Bold";
      font-family-italic = "FiraCode Nerd Font Italic";
      font-family-bold-italic = "FiraCode Nerd Font Italic Bold";
    };
  };
}
