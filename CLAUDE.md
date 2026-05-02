# NixOS Config

Multi-host Nix flake configuration supporting NixOS (Linux) and nix-darwin (macOS).

## Hosts

| Host | OS | Arch | Description |
|---|---|---|---|
| **stormbringer** | NixOS | x86_64-linux | Primary Linux desktop |
| **mjolnnir** | nix-darwin | aarch64-darwin | macOS host (Homebrew integration) |
| **bifrost** | nix-darwin | aarch64-darwin | M4 Mac Mini media server (Jellyfin, NAS mount via rclone/WebDAV) |

Primary development happens on **stormbringer**. When making changes to shared modules (`common/`, `common-linux/`), verify they won't break **mjolnnir**, **bifrost**, or other hosts.

## Build Commands

```bash
# NixOS (stormbringer)
sudo nixos-rebuild switch --flake .#stormbringer

# macOS (mjolnnir)
darwin-rebuild switch --flake .#mjolnnir

# macOS server (bifrost) — deploy via SSH from stormbringer
darwin-rebuild switch --flake .#bifrost

# Update flake inputs
nix flake update
```

## Repository Structure

```
flake.nix                          # Entry point -- defines inputs, hosts, and helper functions
configuration/
  common/                          # Settings shared across ALL hosts (Linux + macOS)
  common-linux/                    # Shared Linux settings (bootloader, locales, networking)
  common-linux-server/             # Linux server additions (e.g. Docker)
  common-darwin-server/            # Shared darwin server settings (Colima, users)
  hosts/<hostname>/                # Host-specific system config
home-manager/
  modules/
    common/                        # Core user packages, fish shell, starship
    development-cli/               # Git, tmux, CLI dev tools
    gaming/                        # Gaming software
    graphical/                     # GUI apps (Firefox, etc.)
    nixvim/                        # Neovim config via nixvim (highly modular)
    plasma-manager/                # KDE Plasma settings
  hosts/<hostname>/<user>/home.nix # Per-host, per-user Home Manager entry point
pub-keys/                          # SSH public keys
scripts/                           # Helper scripts
```

## Conventions

- **Modularity**: Prefer creating new modules over adding to existing files. Each concern should have its own file/module.
- **No hardcoded users**: User info (`user`, `hostname`, `stateVersion`) flows via `specialArgs` from `flake.nix`. Never hardcode usernames or host-specific values in modules.
- **nixpkgs channel**: Uses `nixos-unstable`.
- **Secrets**: Managed via `agenix` (age-encrypted, integrated as a NixOS module).

## Deploying to bifrost

bifrost is managed remotely from stormbringer. To deploy changes:

1. Make changes locally in this repository on stormbringer.
2. Push to remote (`git push`).
3. SSH into bifrost: `ssh -i ~/.ssh/pi_key alin@10.69.100.144`
4. Pull changes on bifrost: `cd /Users/alin/Projects/nixos-config && git pull`
5. Apply the configuration: `sudo darwin-rebuild switch --flake .#bifrost`

## Flake Architecture

- `specialArgs` propagates `inputs`, `stateVersion`, `hostname`, and `user` to all modules.
- `makeLinuxSystem` / `makeDarwinSystem` helper functions build host configs.
- Home Manager is integrated as a NixOS/darwin module (not standalone).
