# Repository Overview

This repository contains the configuration for multiple hosts using Nix flakes and Home Manager. It supports both NixOS (Linux) and nix-darwin (macOS), with a modular structure for easy reuse and maintenance.

## Key Components

### 1. System Configurations (`configuration/`)
Contains system-wide settings, hardware configurations, and services.

- **`common/`**: Settings shared by all operating systems (Linux and macOS).
  - `configuration.nix`: Core shared configuration entry point.
  - `modules/`: Shared modules such as user definitions (`users.nix`).
- **`common-linux/`**: Shared settings for Linux-based systems.
  - `configuration.nix`: Main Linux configuration entry point (bootloader, locales, etc.).
  - `modules/`: Linux-specific components like networking, OpenSSH, and user management.
- **`common-linux-server/`**: Specialized settings for Linux servers (e.g., Docker modules).
- **`hosts/`**: Host-specific configuration directories:
  - **`stormbringer/`**: Configuration for the main Linux (NixOS) host (x86_64-linux). Includes specific hardware settings, sound, networking, and local services like Jellyfin and DSLR camera integration.
  - **`mjolnnir/`**: Configuration for the macOS (nix-darwin) host (aarch64-darwin). Manages macOS-specific settings like TouchID for sudo, Homebrew integration, and system defaults.

### 2. User Configurations (`home-manager/`)
User environments, dotfiles, and software managed via Home Manager.

- **`modules/`**: Modular, reusable Home Manager configurations:
  - `common/`: Core user packages, fish shell, and starship prompt.
  - `development-cli/`: Git, tmux, and essential CLI tools.
  - `gaming/`: Gaming-related software and configurations.
  - `graphical/`: GUI applications (Firefox, packages).
  - `nixvim/`: A comprehensive Neovim setup using `nixvim`, including custom plugins and themes.
  - `plasma-manager/`: KDE Plasma desktop environment settings.
- **`hosts/`**: Host-specific user settings (e.g., `alin` on `stormbringer` and `mjolnnir`).

### 3. Other Directories
- **`pub-keys/`**: Stores public SSH keys for user `alin`.
- **`scripts/`**: Helper scripts like `monitor_change.sh`.

## Package Management

Software is defined across multiple files depending on its scope:

- **System-wide Packages**: `configuration/common/packages.nix` (shared utilities, fonts).
- **User-specific Packages**:
  - `home-manager/modules/common/packages.nix`: Core user packages.
  - `home-manager/modules/development-cli/packages.nix`: Development tools (JDK, SDKs, direnv, git-credential-manager).
  - `home-manager/modules/graphical/packages.nix`: GUI applications (VSCode, JetBrains IDEs, Spotify, browsers).
  - `home-manager/modules/gaming/packages.nix`: Gaming-related software.

## Common Commands

### Applying Configurations
- **NixOS (Linux)**:
  ```bash
  sudo nixos-rebuild switch --flake .#stormbringer
  ```
- **nix-darwin (macOS)**:
  ```bash
  darwin-rebuild switch --flake .#mjolnnir
  ```

### Updating Flake
```bash
nix flake update
```

## Detailed Component Breakdowns

### Nixvim Setup (`home-manager/modules/nixvim/`)
The Neovim configuration is highly modular:
- `default.nix`: Main entry point importing all sub-modules.
- `nixvim.nix`: Core Neovim options and basic settings.
- `plugins/default.nix`: Orchestrates plugin definitions including:
  - **File Explorer**: `neo-tree.nix`, `oil` (lazy-loaded).
  - **UI/Bars**: `barbar.nix` (tabs), `lualine.nix` (statusline).
  - **Search/Nav**: `telescope.nix`, `treesitter.nix`.
  - **Git**: `gitsigns.nix`.
  - **Other**: `comment.nix`, `trim.nix`, `markdown-preview.nix`.

### Scripts (`scripts/`)
- **`monitor_change.sh`**: A utility script to toggle monitor inputs (0x0f/0x11) using `ddcutil`. It accepts `--sn` or `--model` as arguments followed by the device identifier.

## Flake Structure (`flake.nix`)

The `flake.nix` file is the repository's entry point, defining inputs and orchestrating host outputs. It uses `specialArgs` to propagate essential variables like `hostname`, `user`, and `stateVersion` throughout the entire configuration tree.

### Dependencies (Inputs)

The configuration relies on several external flakes to provide specialized functionality:

- **`nixpkgs`**: Uses the `nixos-unstable` channel for the latest software and NixOS modules.
- **`home-manager`**: Manages user-specific configuration (dotfiles, user packages). It is integrated directly into both NixOS and nix-darwin configurations.
- **`nixvim`**: A Nix-centric Neovim configuration framework used to build a highly customized editor.
- **`darwin` (nix-darwin)**: Provides Nix-based system configuration for macOS, similar to NixOS.
- **`nix-cachyos-kernel`**: Provides optimized Linux kernels (CachyOS) and is used on the `stormbringer` host.
- **`agenix`**: A tool for managing secrets (like passwords or API keys) encrypted with `age`, integrated into NixOS modules.
- **macOS Utilities**:
  - `mac-app-util`: Improves how Nix-installed GUI applications behave on macOS (e.g., appearing in Spotlight).
  - `nix-homebrew`: A bridge to manage Homebrew taps and packages declaratively within nix-darwin.
  - `homebrew-core`, `homebrew-cask`, `homebrew-bundle`: These are non-flake inputs used as taps for `nix-homebrew`.

### Outputs and Logic

- **`nixosConfigurations`**: Generated for Linux hosts (currently `stormbringer`).
  - Uses `makeLinuxSystem` helper function.
  - Integrates `home-manager` as a NixOS module.
  - Applies the `nix-cachyos-kernel` overlay for optimized performance.
  - Includes `agenix` for secret management.
- **`darwinConfigurations`**: Generated for macOS hosts (currently `mjolnnir`).
  - Uses `makeDarwinSystem` helper function.
  - Configures `nix-homebrew` with specific taps for declarative macOS package management.
  - Integrates `mac-app-util` for better desktop integration.
