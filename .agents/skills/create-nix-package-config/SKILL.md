---
name: create-nix-package-config
description: Create a new package-layer Nix configuration module in this repository. Use when Codex needs to add packages/name/default.nix, optional packages/name/home-manager.nix user configuration, package helper files, package-local bls.pkgs.name options, system defaults, documentation updates, and non-building validation for the repo's bls package configuration architecture.
---

# Create Nix Package Config

## Overview

Create plug-and-play package configuration modules for this repo's `packages/*` layer. The output must evaluate cleanly as a Nix module and follow the decisions in `docs/packages.md`.

## Workflow

1. Inspect `docs/packages.md`, `packages/default.nix`, `definitions/default.nix`, and nearby package examples before editing.
2. Inspect active/stable configuration for the package being migrated so behavior is preserved intentionally.
3. When migrating from an existing Home Manager module, ask what should stay Home Manager-scoped and what should move to system state. Present concrete choices with a recommendation.
4. Ask before adding shared definitions under `definitions/`. Offer 2-3 concrete options and mark one as recommended.
5. Ask before encoding package interactions where one package influences another. Prefer an interactive decision over guessing.
6. Check upstream NixOS and Home Manager options for useful additional settings. Ask before adding non-trivial settings that were not already in active config.
7. Create or update `packages/<name>/default.nix`; when the package has Home Manager configuration, move it to `packages/<name>/home-manager.nix` and import that file from `default.nix`. Add other helper files like `abbrs.nix` only when they keep package-local behavior clearer.
8. Update `docs/packages.md` when the change establishes or changes an architecture decision.
9. Run non-building validation. Do not build host systems unless the user explicitly asks.

## Package Module Rules

- Put all custom public options under `bls.*`.
- Use `bls.pkgs.<name>.enable` for package enablement.
- Avoid `bls.pkgs` options that mirror upstream options one-to-one.
- Declare package-local options inside the package module.
- Put cross-package or broader domain choices in `definitions/`, but ask before creating them.
- Use `lib.mkDefault` for preferred defaults unless there is a concrete reason not to.
- Guard platform-specific settings with checks such as `pkgs.stdenv.isLinux` or `pkgs.stdenv.isDarwin`.
- Keep Home Manager configuration out of `default.nix`. Put it in `home-manager.nix` beside `default.nix`, and add `imports = [ ./home-manager.nix ];` in `default.nix`.
- Parameterize user-specific Home Manager configuration with the existing `user` module argument.
- Use `packages/module-support.nix` for package-layer helper functions. In package modules, import it as `packageSupport = import ../module-support.nix { inherit lib; };`.
- Put Home Manager-only options under `home-manager.users.${user}` and guard the whole branch with `lib.optionalAttrs hasHomeManager`, not `lib.mkIf hasHomeManager`.
- Keep the Home Manager split simple for the current single-user architecture. Do not add multi-user abstractions; continue to target only `home-manager.users.${user}`.
- Do not write Home Manager-only options at top-level NixOS paths. For example, `programs.fzf.defaultOptions` belongs under Home Manager, not top-level `programs.fzf`, because NixOS has a different `programs.fzf` option surface.
- Do not modify active host/shared imports unless the user explicitly asks to wire the package layer into active configuration.

## Migration Questions

When migrating an old Home Manager package module, stop after inspection and ask a short, concrete series of placement questions.

Ask about these categories when they apply:

- Package installation: keep in `home.packages`, move to `environment.systemPackages`, use a native `programs.<name>.enable`, or split between system and Home Manager.
- User identity, accounts, credentials, or local paths: keep package-local, promote to shared `definitions/`, omit from the package layer, or keep in the old active module.
- CLI integrations and shell/editor hooks: keep in the package module, move to the related package module, or defer until a broader abstraction exists.
- Companion tools: keep with the package, leave in the old package list, or ask for a separate package module.
- Enablement default: preserve current always-on behavior, default from another `bls.*` option, or default to `false`.

Prefer one recommended option and 1-2 alternatives. Continue only after the user confirms or chooses.

When a package exposes useful settings not present in the old config, ask before adding them. Only propose settings that are relevant to the user's package and repo style, such as defaults, integrations, completions, credential helpers, LFS support, keybindings, or platform-specific behavior. Avoid offering a long menu of upstream options or adding 1:1 mirror `bls.*` options.

## Valid Module Shape

If a module defines `options`, put configuration under `config`. Do not mix explicit `options` with free-floating top-level config like `programs.*`.

Use this `default.nix` shape when the package has Home Manager configuration:

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bls.pkgs.<name>;
in
{
  imports = [
    ./home-manager.nix
  ];

  options.bls.pkgs.<name>.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable preferred <name> configuration.";
  };

  config = lib.mkIf cfg.enable {
    # System-level defaults go here.
  };
}
```

Use this `home-manager.nix` shape for the package-local Home Manager branch:

```nix
{
  config,
  lib,
  options,
  user,
  ...
}:
let
  packageSupport = import ../module-support.nix { inherit lib; };

  cfg = config.bls.pkgs.<name>;
  hasHomeManager = packageSupport.hasHomeManager options;
in
{
  config = lib.mkIf cfg.enable (lib.optionalAttrs hasHomeManager {
    home-manager.users.${user} = {
      # Home Manager defaults go here.
    };
  });
}
```

If a package has no Home Manager configuration, omit `home-manager.nix` and the import. If the target context is intentionally Home Manager-only, the module may use Home Manager options directly, but it still must evaluate in the intended import context and the validation command must reflect that context. In mixed NixOS/Home Manager package modules, prefer top-level system options for system state and guarded `home-manager.users.${user}` branches for user state in `home-manager.nix`.

## Package Interactions

When one package can influence another, stop and ask. Present concrete choices with a recommendation.

Typical choices:

- Integration only: package A sets native integration defaults for package B but does not enable `bls.pkgs.b.enable`.
- Default enable: package A makes package B enabled by default.
- Deferred: no relationship is encoded until the abstraction layer exists.

Do not add 1:1 mirror options such as `bls.pkgs.fzf.enableFishIntegration` just to forward to an upstream option.

## Shared Definitions

Ask before adding or changing anything in `definitions/`.

When asking, include:

- A recommended shared definition name, such as `bls.flakeDir`.
- An alternative package-local hardcoded/default value.
- An alternative to defer the shared definition and require the caller to provide the option elsewhere.

Only create the definition after the user chooses or confirms the recommended option.

## Validation

Run parse checks for changed Nix files:

```bash
nix-instantiate --parse packages/<name>/default.nix
nix-instantiate --parse packages/<name>/home-manager.nix # when this file exists
```

Run `nix flake show` to confirm the flake still parses without building hosts.

Run a synthetic `lib.evalModules` check that imports `definitions/default.nix` and the new package module, with stub options for any external module options the package writes. This catches missing `bls.*` definitions and invalid module shape.

Run a plain NixOS module eval without Home Manager imported for mixed-context package modules. This catches accidental `home-manager` option emission and Home Manager-only options written at top-level NixOS paths. If the package also writes Home Manager config, run a second synthetic eval with a narrow `home-manager.users` stub and assert the guarded user config from `home-manager.nix` is present.

Do not run `nixos-rebuild`, `darwin-rebuild`, or `nix build .#nixosConfigurations.*` unless the user explicitly requests host builds.

## Completion Criteria

- The package module parses.
- The package module evaluates in a synthetic module check.
- Mixed-context modules evaluate in plain NixOS without Home Manager imported.
- Home Manager branches are emitted only when `home-manager.users` exists.
- When present, Home Manager configuration lives in `packages/<name>/home-manager.nix`, and `packages/<name>/default.nix` imports it.
- Package-local options live under `bls.pkgs.<name>`.
- Any shared definitions were explicitly approved.
- Package interactions were explicitly approved.
- Home Manager-to-system placement decisions were explicitly approved when migrating old Home Manager config.
- Additional upstream settings were either explicitly approved or intentionally deferred.
- `docs/packages.md` reflects any new architecture decisions.
