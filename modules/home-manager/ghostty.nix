{pkgs, ...}: {
  # broken package
  # home.packages = [pkgs.ghostty];

  xdg.configFile."ghostty/config".text = ''

    shell-integration = zsh
    theme = catppuccin-mocha
    background-opacity = 0.8
    background-blur-radius = 18
    font-family = FiraCode Nerd Font
    font-family-bold = FiraCode Nerd Font Bold
    font-family-italic = FiraCode Nerd Font Italic
    font-family-bold-italic = FiraCode Nerd Font Italic Bold
  '';
}
