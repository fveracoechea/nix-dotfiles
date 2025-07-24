# 💻 Development Environment Configuration

A comprehensive NixOS/nix-darwin dotfiles configuration providing a consistent
and optimized development experience across macOS and Linux systems using Nix
flakes.

![image](https://github.com/user-attachments/assets/0bda1c39-f4b4-4793-98a6-0feab74aff18)

![image](https://github.com/user-attachments/assets/f42234d5-0883-4fe2-b6f5-44e57c55dbc0)

## 🎯 Main Features

- **Keyboard Focused**: Efficient tiling window management with Hyprland
- **Minimal Distractions**: Clean, focused interface design
- **Configuration as Code**: Everything managed through Nix flakes
- **Highly Customizable**: Modular configuration with easy customization
- **Reproducible**: Identical environments across multiple machines
- **Cross-Platform**: Supports both NixOS and macOS (nix-darwin)

## 🖥️ Supported Systems

- **NixOS Desktop** (`nixos-desktop`): x86_64-linux gaming/development setup
- **MacBook Pro** (`macbook-pro`): aarch64-darwin mobile development environment

## 🛠️ Core Tooling

### System & Package Management

- **[Nix Flakes](https://nixos.org/)**: Reproducible package management and
  system configuration
- **[Home Manager](https://github.com/nix-community/home-manager)**: User
  environment management
- **[Stylix](https://github.com/danth/stylix)**: System-wide color scheme and
  styling

### Window Management & Desktop

- **[Hyprland](https://hyprland.org/)**: Dynamic tiling Wayland compositor
- **[HyprPanel](https://github.com/Jas-SinghFSU/HyprPanel)**: Feature-rich
  status bar
- **[SDDM](https://github.com/sddm/sddm)**: Display manager (NixOS)
- **[Ghostty](https://mitchellh.com/ghostty)**: Fast, GPU-accelerated terminal
  emulator

### Development Environment

- **[Neovim](https://neovim.io/)**: Extensible text editor with custom
  configuration
- **[TMUX](https://github.com/tmux/tmux)**: Terminal multiplexer with custom
  scripts
- **[Zsh](https://zsh.sourceforge.io/)** +
  **[Oh My Posh](https://ohmyposh.dev/)**: Enhanced shell experience
- **[LazyGit](https://github.com/jesseduffield/lazygit)**: Terminal UI for Git
  operations
- **[Yazi](https://yazi-rs.github.io/)**: Blazing fast terminal file manager

### Additional Tools

- **[Volta](https://volta.sh/)**: JavaScript toolchain manager
- **[Bat](https://github.com/sharkdp/bat)**: Enhanced `cat` with syntax
  highlighting
- **[Fuzzel](https://codeberg.org/dnkl/fuzzel)**: Application launcher for
  Wayland
- **[Karabiner Elements](https://karabiner-elements.pqrs.org/)**: Keyboard
  customization (macOS)

## 🎨 Theming

- **[Catppuccin](https://catppuccin.com/)**: Consistent soothing pastel theme
  across all applications
- **Custom wallpapers**: Curated collection in `wallpapers/` directory
- **System-wide styling**: Managed through Stylix for consistent appearance

## 🚀 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/fveracoechea/dotfiles.git ~/.config/dotfiles
   cd ~/.config/nixos
   ```

2. **Apply configuration:**

   **For NixOS:**
   ```bash
   sudo nixos-rebuild switch --flake .#nixos-desktop
   ```

   **For macOS:**
   ```bash
   darwin-rebuild switch --flake .#macbook-pro
   ```

3. **Test configuration (optional):**
   ```bash
   # NixOS
   sudo nixos-rebuild test --flake .#nixos-desktop

   # macOS
   darwin-rebuild check --flake .#macbook-pro
   ```

## 📁 Repository Structure

```
├── hosts/                    # Host-specific configurations
│   ├── nixos-desktop/       # NixOS desktop configuration
│   └── macbook-pro/         # macOS configuration
├── modules/                  # Reusable configuration modules
│   ├── nixos/               # NixOS-specific modules
│   ├── darwin/              # macOS-specific modules
│   └── home-manager/        # User environment modules
├── packages/                # Custom packages and scripts
│   └── scripts/             # TypeScript utility scripts
├── utils/                   # Utility functions
├── wallpapers/              # Wallpaper collection
└── flake.nix               # Main flake configuration
```

## 📄 License

This configuration is provided as-is for educational and personal use.
