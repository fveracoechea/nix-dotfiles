# Dotfiles Context

Personal NixOS/nix-darwin dotfiles repository using flakes. Manages reproducible, cross-platform development environments across multiple physical machines.

## Language

**Host**:
A physical machine managed by this repository. Each host has its own directory under `hosts/` containing system and user configuration.

**Custom Utils**:
Shared utilities injected into all modules via `specialArgs`. Currently includes `catppuccin` (color palette) and `monitors` (display configuration strings).
_Avoid_: utils, helpers, constants

**Custom Package**:
A package defined locally in this repository and built via `callPackage`, not available in nixpkgs.
_Avoid_: local package, in-repo package

**Custom Pkgs**:
The set of custom packages built for the target system and injected into all modules via `specialArgs`. These are packages that are either pinned to a specific version or not available in nixpkgs.

**Theme**:
A visual style applied consistently across applications. Themes are configured per-application in each module rather than via a unified theming framework like Stylix.
_Avoid_: color scheme, palette, style

**State Version**:
A compatibility marker (`system.stateVersion` or `home.stateVersion`) that preserves migration behavior across Nix/Home Manager upgrades.
_Avoid_: version, state

**System**:
OS-level configuration for a host. On NixOS this includes bootloader, networking, services, and hardware. On macOS this includes nix-darwin system defaults and Homebrew.

**Home**:
User-level configuration for a host, managed by Home Manager. Includes dotfiles, shell configuration, applications, and themes.

**Home Manager Module**:
A module under `modules/home-manager/` that configures a user-level concern. These modules are shared across all platforms (NixOS and macOS) and imported into each host's `home.nix`.

**System Module**:
A module under `modules/nixos/` or `modules/darwin/` that configures an OS-level concern specific to one platform. NixOS modules configure bootloader, services, networking, and hardware. Darwin modules configure macOS system defaults, Homebrew, and shell integration.
