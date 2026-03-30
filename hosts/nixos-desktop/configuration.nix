{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/bootloader.nix
    ../../modules/nixos/sddm.nix
    ../../modules/nixos/miscellaneous.nix
    ../../modules/nixos/zsh-shell.nix
    ../../modules/nixos/nix-ld.nix
    ../../modules/nixos/timezone.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/hyprland.nix
    # ../../modules/nixos/ollama.nix
    ../../modules/nixos/networking.nix
  ];

  nix = {
    optimise.automatic = true;
    settings.experimental-features = ["nix-command" "flakes" "impure-derivations" "ca-derivations"];
    gc.automatic = true;
    gc.options = "--delete-older-than 30d";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = ["modesetting"];
  };

  users.users.fveracoechea = {
    isNormalUser = true;
    description = "fveracoechea";
    extraGroups = ["networkmanager" "wheel" "audio" "docker" "dialout" "plugdev"];
  };

  virtualisation.docker.enable = true;

  # Provide GDM's mutter compositor with a safe monitor config for DP-1.
  # GDM runs as its own user and does not inherit Hyprland's monitor settings.
  # Without this, mutter probes the Samsung Odyssey's native 5120x1440@120Hz
  # mode over DisplayPort, which requires DSC negotiation it cannot do correctly,
  # resulting in a scrambled/corrupt display at the login screen.
  # The xml sets 2560x1440@60 (matching the kernel video= param) so the DM
  # renders cleanly; Hyprland takes over with full resolution after login.
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${./gdm-monitors.xml}"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.3.4"
    "beekeeper-studio-5.5.5"
    "beekeeper-studio-5.5.7"
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    zip
    unzip
    cmake
    gnumake
    cargo
    openssl
    lazydocker
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
