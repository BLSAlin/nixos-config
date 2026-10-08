# Configuration Guide

## Hosts and ownership

This flake manages `stormbringer` (x86_64-linux NixOS) and `mjolnnir` and
`bifrost` (aarch64-darwin). Home Manager is integrated for the primary user,
`alin`; there are no standalone Home Manager outputs. Bifrost also declares
`andra` and the `orc` service account, without Home Manager for either.

- `flake.nix` owns pinned inputs and host construction.
- `hosts/<name>/` owns composition, hardware, accounts, mounts, and specialized
  services. `hosts/primary-user.nix` owns the shared primary-user identity.
- `definitions/` declares shared `bls.*` preferences.
- `packages/` auto-imports direct child directories containing `default.nix`.
  These are preference modules, not package derivations. Automatic defaults
  are intentional: importing them can enable tools and, on Linux, services.
- `modules/` composes reusable base, development, graphical, desktop, and
  gaming behavior. Native upstream options remain the override interface.
- `tests/` and `scripts/check-migration.py` provide evaluation-only validation.
- `docs/packages.md` describes package decisions; `docs/migration.md` records
  the immutable baseline, approved differences, and migration status.

## Editing

Use the local `create-nix-package-config` skill for package-layer work. Keep
custom options under `bls.*`; do not mirror upstream options unnecessarily.
Place package-specific Home Manager settings in `home-manager.nix` alongside
`default.nix`, targeting the parametrized `user`. Use Home Manager's own `pkgs`
inside its modules: system overlays and user package sets intentionally differ.

Use `lib.mkDefault` for preferences. Fish's system default shell uses priority
900 to beat upstream's `mkDefault` Bash while allowing host overrides. Omit
unsupported option paths with `lib.optionalAttrs` based on option existence;
`lib.mkIf false` alone does not hide nonexistent options. Avoid using `pkgs`
in top-level `optionalAttrs`, which can cause module evaluation recursion.

Preserve package installation scope, user IDs, state versions, external
credential paths, and user changes unless a change is explicitly authorized.
Do not enable a configuration merely because a historical file exists.
Secrets are not currently provisioned by agenix: its Linux module is loaded,
but the SMB credentials file is an external prerequisite. Never read or copy
credential contents into the repository or Nix store.

## Validation: never activate during testing

Do not run `nixos-rebuild switch`, `nixos-rebuild test`, `nixos-rebuild boot`,
`darwin-rebuild switch`, `home-manager switch`, activation scripts, remote
deployments, or service restarts as validation. No host builds are required.

From the repository root, use:

```sh
nix-instantiate --parse path/to/changed-file.nix
nix flake show --all-systems --no-write-lock-file
nix flake check --all-systems --no-build --no-write-lock-file
nix eval --raw --no-write-lock-file .#nixosConfigurations.stormbringer.config.system.build.toplevel.drvPath
nix eval --raw --no-write-lock-file .#darwinConfigurations.mjolnnir.config.system.build.toplevel.drvPath
nix eval --raw --no-write-lock-file .#darwinConfigurations.bifrost.config.system.build.toplevel.drvPath
nix eval --impure --json --no-write-lock-file --expr 'import ./tests/modules.nix {}'
python3 scripts/check-migration.py --output /tmp/nixos-migration-reports
```

The comparison script checks all hosts against commit `19ede68`, applying only
the explicitly approved editor change to the reference. It exits nonzero on
an evaluation error or any unexpected difference. JSON reports contain full
expected/actual manifests. Keep this Git revision available; shallow clones
must fetch it before running historical comparisons. The regression checks
cover declared state, not runtime hardware, mounts, credentials, or downloaded
Homebrew applications.

Git flakes omit untracked files. Add new modules to Git's index (intent-to-add
is sufficient) before evaluating the final flake. Inspect the diff first;
never stage unrelated user work silently. Nix may need writable caches and
network access for missing locked inputs, but evaluation must not rewrite the
lockfile or activate a host.

## Dependency updates

Treat input updates separately from refactors. When explicitly requested, use
`nix flake update <input>` (or `nix flake update` for all inputs), inspect the
lockfile diff, and rerun evaluation for all three hosts. Never change
`system.stateVersion` or Home Manager's state version as part of an update.
The historical parity test intentionally detects changed package revisions;
review such differences rather than silently relaxing the comparison.
