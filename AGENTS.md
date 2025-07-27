# AGENTS.md - NixOS Dotfiles Repository

## Build & Test Commands
- **Build system config**: `nixos-rebuild switch --flake .#nixos-desktop` or `darwin-rebuild switch --flake .#macbook-pro`
- **Test config**: `nixos-rebuild test --flake .#nixos-desktop` or `darwin-rebuild check --flake .#macbook-pro`
- **Format Nix code**: `nix fmt`
- **Check flake**: `nix flake check`
- **Lint TypeScript**: `deno lint packages/scripts/`
- **Format TypeScript**: `deno fmt packages/scripts/`
- **Run single script**: `deno run --allow-read --allow-run packages/scripts/<script-name>.ts`

## Code Style Guidelines
- **Nix files**: Use 2-space indentation, kebab-case for attributes, follow nixpkgs conventions
- **TypeScript**: Use camelCase, async/await pattern, explicit return types when complex
- **Imports**: Group by type (node:*, npm:*, local), use named imports when possible
- **Error handling**: Use try-catch blocks, return empty strings or default values on failure
- **Naming**: Use descriptive function names (e.g., `isGitRepo`, `run`), kebab-case for file names
- **Structure**: Organize modules by platform (nixos/, darwin/, home-manager/), keep scripts in packages/scripts/
- **Comments**: Minimal inline comments, prefer self-documenting code
- **Files**: .nix for configurations, .ts for scripts, maintain consistent directory structure

## Special Notes
- This is a NixOS/nix-darwin dotfiles repository using flakes
- Scripts use Deno runtime with npm: imports for Node.js packages
- Configuration split by host (nixos-desktop, macbook-pro) and module type
- No traditional package.json - uses deno.jsonc for TypeScript tooling only