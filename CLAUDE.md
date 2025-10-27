# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS flake-based system configuration for hostname "foxos" (user: foxfurry) with Home Manager integration. The system uses Hyprland (Wayland compositor) with NVIDIA drivers and a modular configuration structure.

## System Architecture

### Configuration Entry Points

- `flake.nix` - Flake definition with inputs (nixpkgs-unstable, hyprland, home-manager). Defines nixosConfiguration named "foxfurry"
- `configuration.nix` - System-level configuration (hardware, networking, system packages, services)
- `modules/home.nix` - Home Manager configuration entry point that imports all user-level module categories

### Module Organization

The configuration follows a hierarchical import structure:

```
modules/
├── home.nix              # Imports all module categories
├── development/          # Development tools (kitty, nvim, zsh, ssh, ranger, wofi, dunst, tools)
├── ui/                   # UI components (hyprland, waybar, cava)
├── mimes/                # MIME type associations
└── programs/             # Application configs (VSCode with vim, catppuccin theme)
```

Each category has a `default.nix` that imports its sub-modules. When adding new modules:
- Create a directory under the appropriate category
- Add a `default.nix` in that directory
- Import it in the category's `default.nix`

### Hyprland Configuration

Hyprland configuration uses a hybrid approach (modules/ui/hypr/default.nix:8):
- Main config read from `.config/hypr/hyprland.conf` (outside flake)
- Hyprpaper config symlinked from `.config/hypr/hyprpaper.conf`

When modifying Hyprland settings, edit `.config/hypr/hyprland.conf` directly, not the Nix expression.

## Common Commands

### System Management

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake .#foxfurry

# Test configuration without switching boot default
sudo nixos-rebuild test --flake .#foxfurry

# Build without activating
sudo nixos-rebuild build --flake .#foxfurry

# Update flake inputs (nixpkgs, hyprland, home-manager)
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input hyprland
```

### Garbage Collection

```bash
# Remove old generations and clean up
sudo nix-collect-garbage -d

# Remove generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d
```

### Development

```bash
# Search for packages
nix search nixpkgs <package-name>

# Check flake structure
nix flake show

# Verify flake configuration
nix flake check
```

## Important Configuration Details

### NVIDIA Setup

- Using proprietary drivers (hardware.nvidia.open = false in configuration.nix:59)
- Wayland environment variable set: WLR_NO_HARDWARE_CURSORS = "1" for NVIDIA compatibility
- Video drivers configured for X server compatibility

### System Packages vs Home Manager

- System packages (configuration.nix:116-142): Installed system-wide, require sudo rebuild
- Home Manager packages (in module subdirectories): User-level, managed through home-manager

### Cache Configuration

Uses both official NixOS cache and Hyprland cachix (configuration.nix:104-111) for faster builds.

## State Versions

- System: 23.11 (configuration.nix:180)
- Home Manager: 23.11 (modules/home.nix:26)

Do not modify these values unless following official migration guides.
