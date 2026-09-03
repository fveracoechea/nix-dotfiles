{
  description = "My fist NixOS Flake";

  inputs = {
    # Latest channel: apps, CLI, and tooling.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Release channel: system packages, services, and the compositor.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs-stable";

    neovim-config.url = "github:fveracoechea/neovim-nix-config";
    neovim-config.inputs.nixpkgs.follows = "nixpkgs";

    # main required: v0.55-v0.56 tags fail to link hyprland-guiutils against
    # current nixpkgs gcc (hyprwm/Hyprland#discussion-15848)
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs-stable";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    ultrashell.url = "github:fveracoechea/ultrashell";
    ultrashell.inputs.nixpkgs.follows = "nixpkgs";

    tmux-powerkit.url = "github:fabioluciano/tmux-powerkit";
    tmux-powerkit.inputs.nixpkgs.follows = "nixpkgs";

    hunk.url = "github:modem-dev/hunk";
    hunk.inputs.nixpkgs.follows = "nixpkgs";

    figma-plugin.url = "github:figma/mcp-server-guide";
    figma-plugin.flake = false;

    handy.url = "github:cjpais/Handy";
    handy.inputs.nixpkgs.follows = "nixpkgs";
    # bun2nix (handy's dep) evaluates its flake-parts outputs for every system
    # in its `systems` input; nix-systems/default includes x86_64-darwin, which
    # nixpkgs 26.11 dropped, so narrow it to linux-only (handy is linux-only).
    handy.inputs.bun2nix.inputs.systems.follows = "systems";

    systems.url = "github:nix-systems/default-linux";

    herdr.url = "github:herdrdev/herdr";
    herdr.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nix-darwin,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    supportedSystems = ["x86_64-linux" "aarch64-darwin"];

    # Both channels share one config. `nixpkgs.pkgs` takes an already-built
    # instance, and NixOS asserts that `nixpkgs.config` is empty in that case,
    # so hosts cannot declare `allowUnfree` or insecure packages themselves.
    nixpkgsConfig = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "beekeeper-studio-5.3.4"
        "beekeeper-studio-5.5.5"
        "beekeeper-studio-5.5.7"
      ];
    };

    latestPkgsFor = system:
      import nixpkgs {
        inherit system;
        config = nixpkgsConfig;
      };

    stablePkgsFor = system:
      import nixpkgs-stable {
        inherit system;
        config = nixpkgsConfig;
      };

    dotfilesPkgsFor = system: (import ./packages {
      inherit inputs;
      pkgs = latestPkgsFor system;
      pkgs-stable = stablePkgsFor system;
    });

    codingAgentSources = {
      inherit (inputs) figma-plugin herdr hunk;
    };

    # Aggregates close over this flake's own inputs, so consumer flakes do
    # not re-declare them. Third-party modules are imported here because
    # `imports` cannot read module arguments.
    homeManagerModules.default = {
      _module.args = {inherit codingAgentSources;};
      imports = [
        ./modules/home-manager/default.nix
        inputs.spicetify-nix.homeManagerModules.default
      ];
    };
    nixosModules.default = {
      imports = [
        ./modules/nixos/default.nix
        inputs.musnix.nixosModules.musnix
      ];
    };
    darwinModules.default = {
      imports = [
        ./modules/darwin/default.nix
        # Installs into environment.systemPackages so nix-darwin links
        # Spotify.app into /Applications/Nix Apps for Spotlight/Launchpad.
        inputs.spicetify-nix.darwinModules.default
      ];
    };

    neovimChecks = system:
      import ./checks/neovim.nix {
        inherit lib inputs system;
        pkgs = latestPkgsFor system;
      };
  in {
    inherit homeManagerModules nixosModules darwinModules;

    checks = builtins.listToAttrs (map (system: {
        name = system;
        value = neovimChecks system;
      })
      supportedSystems);

    dotfilesPkgs = builtins.listToAttrs (map (system: {
        name = system;
        value = dotfilesPkgsFor system;
      })
      supportedSystems);

    # This host does not split channels: nix-darwin asserts that its own branch
    # matches the Nixpkgs branch, so a release-channel system layer here would
    # also need a second nix-darwin input and the `nixpkgs-YY.MM-darwin` branch.
    # Its apps come from Homebrew (ADR-0003), so the split would buy little.
    # `pkgs-stable` is still passed, unforced, to keep one signature for the
    # shared home modules. See ADR-0007.
    darwinConfigurations.macbook-pro = let
      system = "aarch64-darwin";
      pkgs-latest = latestPkgsFor system;
      specialArgs = {
        dotfilesPkgs = dotfilesPkgsFor system;
      };
    in
      nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        modules = [
          darwinModules.default
          ./hosts/macbook-pro/configuration.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.pkgs = pkgs-latest;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.fveracoechea = {
              imports = [homeManagerModules.default ./hosts/macbook-pro/home.nix];
            };
            home-manager.extraSpecialArgs =
              specialArgs
              // {
                pkgs-stable = stablePkgsFor system;
              };
          }
        ];
      };

    nixosConfigurations.nixos-desktop = let
      system = "x86_64-linux";
      pkgs-stable = stablePkgsFor system;
      pkgs-latest = latestPkgsFor system;
      specialArgs = {
        dotfilesPkgs = dotfilesPkgsFor system;
      };
    in
      nixpkgs-stable.lib.nixosSystem {
        inherit specialArgs;

        modules = [
          nixosModules.default
          inputs.handy.nixosModules.default
          ./hosts/nixos-desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            # System layer runs on the release channel.
            nixpkgs.hostPlatform = system;
            nixpkgs.pkgs = pkgs-stable;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.fveracoechea = {
              imports = [homeManagerModules.default ./hosts/nixos-desktop/home.nix];
              # Home layer runs on the latest channel. `useGlobalPkgs` hands
              # Home Manager the system `pkgs` at default priority, so this
              # plain definition replaces it.
              _module.args.pkgs = pkgs-latest;

              # Home Manager and `pkgs` are both on the latest channel, but the
              # NixOS module tree evaluates Home Manager with the release
              # channel's `lib`. That third-party mismatch is deliberate and
              # unavoidable here. See ADR-0007.
              home.enableNixpkgsReleaseCheck = false;
            };
            home-manager.extraSpecialArgs = specialArgs // {inherit pkgs-stable;};
          }
        ];
      };
  };
}
