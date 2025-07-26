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
}
