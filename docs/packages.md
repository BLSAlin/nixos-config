# Package Layer Decisions

This document records the current design decisions for the `packages/*` proof of concept. Update it whenever these decisions change.

## Goal

`packages/*` contains curated preference modules for tools used across machines. Each package module should encode the preferred defaults for that tool, while later abstraction modules will decide which packages are enabled for a host.

The initial proof of concept covers `fish` and `fzf` only. It is intentionally decoupled from active host configuration until the files are manually validated.

## Option Namespace

All custom options live under `bls.*`.

Package enablement uses `bls.pkgs.<name>.enable`. Avoid adding `bls.pkgs` options that mirror upstream module options one-to-one. For example, `bls.pkgs.fzf.enable` is acceptable, but `bls.pkgs.fzf.enableFishIntegration` should not exist just to mirror Home Manager's `programs.fzf.enableFishIntegration`.

Options that only affect one package may be declared in that package module. Options that coordinate multiple packages or model a broader choice belong in `definitions/`. `bls.shell.defaultShell` is a shared definition because more shells may be added later.

Package-specific Home Manager configuration lives in `packages/<name>/home-manager.nix`, imported from the package's `default.nix`. The current package layer targets the single parametrized user with `home-manager.users.${user}`; multi-user Home Manager support is deferred.

Package modules use `packages/module-support.nix` for shared package-layer helpers. Home Manager-only branches should use `packageSupport.hasHomeManager options` and guard `home-manager.users.${user}` with `lib.optionalAttrs`, so package modules still evaluate when Home Manager is not imported.

## Imports

`definitions/default.nix` aggregates shared `bls.*` definitions.

`packages/default.nix` auto-imports direct child directories that contain a `default.nix`. This allows new package modules to be added without updating an import list.

During the proof of concept, neither aggregator is imported by active host or shared configuration.

## Package Relationships

Package modules may set native integration defaults for other packages without enabling those packages through `bls.pkgs`.

For example, enabling fish sets Home Manager's native fzf fish integration default, but it does not set `bls.pkgs.fzf.enable = true`.

## Current Package Decisions

`bls.shell.defaultShell` defaults to `"fish"`.

`bls.editor.default` defaults to `"helix"`.

`bls.editor.choices` maps editor names to editor metadata. The default
choice maps `helix.command` to `"hx"`.

`bls.editor.command` resolves to the command for `bls.editor.default`.

`bls.pkgs.fish.enable` defaults to `true` when `bls.shell.defaultShell == "fish"`.

When fish is enabled, it should enable system fish support, set the Linux default user shell to `pkgs.fish`, and configure Home Manager fish defaults for the primary parametrized `user`.

`bls.pkgs.fzf.enable` defaults to `true` to match the current stable Home Manager behavior.

When fzf is enabled, it should configure Home Manager fzf defaults for the primary parametrized `user`.

`bls.pkgs.starship.enable` defaults to `true` when `bls.pkgs.fish.enable` is `true`.

When Starship is enabled, it should configure Home Manager Starship defaults for the primary parametrized `user`, including the package-local `starship.toml`. Starship remains Home Manager-scoped and its fish integration defaults from `bls.pkgs.fish.enable`.

`bls.pkgs.git.enable` defaults to `true` to match the current stable git behavior.

When git is enabled, it should install git at the system level, configure Home Manager git defaults for the primary parametrized `user`, and keep `git-credential-manager` with the git package module. Git identity and credential defaults are package-local for now.

`bls.pkgs.firefox.enable` defaults to `false`. Higher-level modules such as
`bls.pcUse` should enable it when Firefox is selected as the browser.

When Firefox is enabled, it should configure Home Manager Firefox defaults for the primary parametrized `user`. Firefox policies, search engines, and extension settings stay Home Manager-scoped for now; the package layer does not install Firefox at the system level.

`bls.pkgs.helix.enable` defaults to `true` when `bls.editor.default == "helix"`.

When Helix is enabled, it should install `pkgs.helix` at the system level. When Helix is the default editor, it should set the system session `EDITOR` and `VISUAL` variables to `bls.editor.command`.

Helix user configuration should use Home Manager's `programs.helix` module. This means Helix is present in both the system and Home Manager profiles when enabled. The current defaults set the `ayu_evolve` theme and enable Nix auto-formatting through `pkgs.nixfmt`.

`bls.pkgs.tmux.enable` defaults to `true` to match the current stable tmux behavior.

When tmux is enabled, it should install `pkgs.tmux` at the system level and configure Home Manager tmux defaults for the primary parametrized `user`.

`bls.pkgs.gamemode.enable` defaults to `true` to match the current stable GameMode behavior.

When GameMode is enabled on Linux, it should enable the native NixOS `programs.gamemode` module. GameMode has no Home Manager configuration in the package layer.

`bls.pkgs.gamescope.enable` defaults to `false`.

When Gamescope is enabled on Linux, it should enable the native NixOS `programs.gamescope` module. Gamescope has no Home Manager configuration in the package layer.

`bls.pkgs.steam.enable` defaults to `true` to match the current stable Steam behavior.

When Steam is enabled on Linux, it should enable the native NixOS `programs.steam` module, open the Remote Play and local network game transfer firewall rules by default, include KDE Breeze as a Steam extra package, and include Proton-GE as an extra compatibility package. Steam has no Home Manager configuration in the package layer.

Once desktop environment settings exist in the package layer, revisit the Steam module so KDE Breeze is included only when the configured desktop environment uses KDE/Plasma.

`bls.pkgs.kdeconnect.enable` defaults to `true` to match the current stable Home Manager behavior.

When KDE Connect is enabled, it should configure Home Manager's KDE Connect service for the primary parametrized `user` on Linux only. KDE Connect remains Home Manager-scoped for now.

Once desktop environment settings exist in the package layer, revisit the KDE Connect module so it is enabled only when the configured desktop environment uses KDE/Plasma.

`bls.pkgs.vscode.enable` defaults to `false`.

When VS Code is enabled, it should configure Home Manager's VS Code program for the primary parametrized `user`. VS Code remains Home Manager-scoped and is not installed at the system level.

`bls.pkgs.direnv.enable` defaults to `true` to match the current stable direnv behavior.

When direnv is enabled, it should configure the system-wide NixOS direnv program and enable nix-direnv integration. Direnv is installed at the system level and is not configured through Home Manager.

`bls.pkgs.sunshine.enable` defaults to `true` to match the current stable Sunshine behavior.

When Sunshine is enabled on Linux, it should enable the native NixOS `services.sunshine` module, start Sunshine automatically, grant the service `CAP_SYS_ADMIN`, open Sunshine firewall rules, and include the Steam Big Picture application shortcut. The host-specific `settings.output_name` value intentionally stays out of the package layer.

Unsupported platform-specific settings must be guarded so the package layer can evaluate on both NixOS and nix-darwin.

Multi-user Home Manager support and higher-level abstraction modules are deferred until the base package layer is stable.
