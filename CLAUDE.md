# Nix Configuration

Read [AGENTS.md](AGENTS.md) for authoritative repository ownership, editing,
dependency-update, and evaluation-only testing instructions.

The active flake manages:

| Host | Platform | Purpose |
|---|---|---|
| stormbringer | x86_64-linux | NixOS desktop |
| mjolnnir | aarch64-darwin | macOS workstation |
| bifrost | aarch64-darwin | macOS workstation and media/container services |

Configuration now uses `hosts/`, `modules/`, `packages/`, and `definitions/`.
The old `configuration/` and `home-manager/` trees are preserved in Git history
at baseline commit `19ede68`, not imported by current outputs.

Home Manager is integrated for the parametrized primary user, not standalone.
System and Home Manager package sets remain separate. All hosts use minimal
Helix instead of Nixvim. Bifrost's extra accounts do not gain Home Manager.

Agenix's NixOS module is available, but this repository currently declares no
age-managed secrets. SMB credentials remain an external file prerequisite.

See [docs/packages.md](docs/packages.md) for defaults and profile semantics,
and [docs/migration.md](docs/migration.md) for approved differences and parity
evidence. Do not activate, deploy, restart services, or build host systems as
part of testing; use the commands in AGENTS.md.
