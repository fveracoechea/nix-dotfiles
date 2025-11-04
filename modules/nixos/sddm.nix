{pkgs, ...}: {
  environment.systemPackages = [
    (
      pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "Fira Sans";
        accent = "blue";
        fontSize = "14";
        background = "${../../wallpapers/catppuccin-mocha/dark-forrest-ultrawide.png}";
        loginBackground = false;
      }
    )
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland = true;
    enableHidpi = true;
    theme = "catppuccin-mocha-blue";
    package = pkgs.kdePackages.sddm;
  };
}
