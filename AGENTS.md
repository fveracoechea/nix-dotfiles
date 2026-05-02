# AGENTS.md - NixOS Dotfiles Repository

## Build & Test Commands
- **Build system config**: `nixos-rebuild switch --flake .#nixos-desktop` or `darwin-rebuild switch --flake .#macbook-pro`
- **Test config**: `nixos-rebuild test --flake .#nixos-desktop` or `darwin-rebuild check --flake .#macbook-pro`
- **Format Nix code**: `nix fmt`
- **Check flake**: `nix flake check`

## Code Style Guidelines
- **Nix files**: Use 2-space indentation, kebab-case for attributes, follow nixpkgs conventions
- **Naming**: Use descriptive function names, kebab-case for file names
- **Structure**: Organize modules by platform (nixos/, darwin/, home-manager/)
- **Comments**: Minimal inline comments, prefer self-documenting code
- **Files**: .nix for configurations, maintain consistent directory structure

## Special Notes
- This is a NixOS/nix-darwin dotfiles repository using flakes
- Configuration split by host (nixos-desktop, macbook-pro) and module type