{pkgs, ...}: {
  environment.systemPackages = [
    (
      pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "Fira Sans";
        fontSize = "12";
      }
    )
  ];

  services.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
    theme = "catppuccin-mocha";
  };
}
