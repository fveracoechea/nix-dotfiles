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
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/postgreSQL.nix
  ];

  nix = {
    optimise.automatic = true;
    settings.experimental-features = ["nix-command" "flakes" "impure-derivations" "ca-derivations"];
    gc.automatic = true;
    gc.options = "--delete-older-than 30d";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = ["modesetting"];
    desktopManager = {
      gnome = {
        enable = true;
        extraGSettingsOverridePackages = [pkgs.mutter];
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
        '';
      };
    };
  };

  users.users.fveracoechea = {
    isNormalUser = true;
    description = "fveracoechea";
    extraGroups = ["networkmanager" "wheel" "audio" "docker"];
  };

  virtualisation.docker.enable = true;
  nixpkgs.config.allowUnfree = true;

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
