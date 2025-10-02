{
  description = "My fist NixOS Flake";

  inputs = {
    # NixOS official package sources
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sylix - system wide styles
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Musnix - Real-time audio
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim config flake
    neovim-config = {
      url = "github:fveracoechea/neovim-nix-config/snacks-mini-architecture";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=refs/tags/v0.49.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spotify theme
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprpanel - bar
    # hyprpanel = {
    #   url = "github:Jas-SinghFSU/HyprPanel";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Hyprshell
    hyprshell = {
      url = "github:fveracoechea/hyprshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
    mcp-servers-nix.inputs.nixpkgs.follows = "nixpkgs";

    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    distro-grub-themes.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-darwin,
    hyprpanel,
    ...
  } @ inputs: let
    customUtils = import ./utils;
    customPkgsFor = system: (import ./packages nixpkgs.legacyPackages.${system});
  in {
    # `macbook-pro` configuration
    darwinConfigurations."macbook-pro" = nix-darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";

      specialArgs = {
        inherit system;
        inherit inputs;
        inherit customUtils;
        customPkgs = customPkgsFor system;
      };

      modules = [
        ./hosts/macbook-pro/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.franciscoveracoechea = import ./hosts/macbook-pro/home.nix;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };

    # `nixos-desktop` configuration
    nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs = {
        inherit system;
        inherit inputs;
        inherit customUtils;
        customPkgs = customPkgsFor system;
      };

      modules = [
        ./hosts/nixos-desktop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          nixpkgs.config.allowUnfree = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.fveracoechea = import ./hosts/nixos-desktop/home.nix;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };
  };
}
