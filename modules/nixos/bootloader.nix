{...}: {
  # Bootloader.
  boot.loader.timeout = 2;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
