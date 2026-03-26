{...}: {
  boot.loader = {
    timeout = 3;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 15;
    };
  };

  # Force a safe KMS mode on DP-1 during early boot / display manager stage.
  # The Samsung Odyssey at 5120x1440@120Hz over DisplayPort requires DSC and
  # specific pixel format negotiation that GDM/mutter cannot handle correctly.
  # This sets a stable 2560x1440@60 mode for the DM; Hyprland overrides it
  # with the full resolution once its compositor starts.
  boot.kernelParams = [ "video=DP-1:2560x1440@60" ];
}
