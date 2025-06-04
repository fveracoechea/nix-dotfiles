# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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
    # Enable the Flakes feature and the accompanying new nix command-line tool
    settings. experimental-features = ["nix-command" "flakes"];

    # optimise store
    optimise.automatic = true;

    # Enable automatic garbage collection
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };

    # GPU drivers
    videoDrivers = ["modesetting"];

    # Enable the GNOME Desktop Environment.
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fveracoechea = {
    isNormalUser = true;
    description = "fveracoechea";
    extraGroups = ["networkmanager" "wheel" "audio" "docker"];
  };

  # enable docker
  virtualisation.docker.enable = true;

  # Allow unfree packages
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
