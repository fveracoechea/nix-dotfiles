{pkgs, ...}: {
  home.packages = [pkgs.ghostty];

  xdg.configFile."ghostty/config".text = ''
    theme = catppuccin-mocha
    font-family = FiraCode Nerd Font
    font-family-bold = FiraCode Nerd Font Bold
    font-family-italic = FiraCode Nerd Font Italic
    font-family-bold-italic = FiraCode Nerd Font Italic Bold
  '';
}
