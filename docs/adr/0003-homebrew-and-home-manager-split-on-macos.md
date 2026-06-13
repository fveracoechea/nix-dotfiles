# Homebrew and Home Manager Split on macOS

macOS GUI applications and some system tools are installed via Homebrew casks rather than nixpkgs. The nix-darwin configuration declares Homebrew casks and brews, while Home Manager handles dotfiles and CLI packages from nixpkgs.

This trade-off accepts reduced reproducibility in exchange for practical support of macOS GUI applications that are poorly packaged or unavailable in nixpkgs. Examples include Docker Desktop, Karabiner Elements, and various productivity apps. Some tools that have a nix-darwin system service (e.g., Karabiner) are also installed via Homebrew when the service module is not functioning correctly.

When a package exists in both nixpkgs and Homebrew, prefer nixpkgs via Home Manager unless the Homebrew version is materially better (e.g., native macOS app bundle vs. XQuartz dependency).
