{pkgs, ...}: {
  home.packages = with pkgs; [
    fira-sans
    nerd-fonts.fira-code
  ];

  fonts.fontConfig = {
    enable = true;
    antialiasing = true;
    defaultFonts = {
      serif = ["Fira Sans"];
      sansSerif = ["Fira Sans"];
      monospace = ["FiraCode Nerd Font"];
      emoji = ["FiraCode Nerd Font"];
    };
  };
}
