{pkgs, ...}: {
  environment.systemPackages = [
    (
      pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "Fira Sans";
        fontSize = "14";
        background = "${../../wallpapers/catppuccin-mocha/dark-forrest-ultrawide.png}";
        loginBackground = false;
      }
    )
  ];

  services.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
  };
}
