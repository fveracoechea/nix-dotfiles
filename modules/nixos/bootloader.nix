{
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.distro-grub-themes.nixosModules.${system}.default
  ];

  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };

  boot.loader = {
    timeout = 3;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };
}
