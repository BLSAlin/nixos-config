# Layered Configuration Migration

## Status

Completed on 2026-10-08. The original host output names now use `hosts/`,
`modules/`, `packages/`, and `definitions/`. Temporary `-next` outputs and
the superseded `configuration/` and `home-manager/` trees were removed.
No system was built or activated, and no services were restarted.

The reference is the working tree selected by the user, not the older running
stormbringer generation. Two commits preserve it:

- `85d0b1c`: the user's original edits, lockfile, documentation, and package skill.
- `19ede689f714ba8b302c5544ea566486adb4ecc2`: the same baseline with mjolnnir's
  missing `user` module argument fixed, allowing all three hosts to evaluate.

Inactive examples, including Andra's Home Manager files, Plasma Manager, Linux
server modules, QMK keyboard setup, and stormbringer's Ollama/Open WebUI setup,
remain recoverable from those commits. They were not enabled by this migration.
For example, `git show 19ede68:configuration/hosts/stormbringer/modules/keyboard.nix`
inspects the old keyboard example without changing any files.

## Approved differences

Helix replaces Nixvim on all hosts. It retains the existing ayu_evolve theme
and Nix autoformatter. Primary-user EDITOR/VISUAL and fish's vim abbreviation
resolve to hx; Darwin's existing global EDITOR also resolves to hx. Nixvim's
plugins and language servers are intentionally removed without replacements.
The separately installed Vim is retained.

Other package inventories, installation scopes, accounts, services, desktop
settings, external credential paths, and state versions are preserved. Eza is
optional and disabled. No Bottles, MangoHud, extra Firefox installation, global
direnv, or system Helix installation was introduced.

Automatic package defaults remain intentional. This simplifies host
composition but means importing packages can enable tools and Linux services.
Native options provide escape hatches. Specialized host service scripts remain
host-owned instead of acquiring wrappers for every upstream option.

Nixvim and its now-unused flake-parts/systems lock nodes were pruned. All
surviving locked revisions and content hashes are unchanged. One systems node
was renumbered by Nix; its locked content did not change. The obsolete agenix
Home Manager input override was removed from flake.nix.

## Equivalence evidence

`scripts/check-migration.py` evaluates the immutable reference and current
outputs using their locked inputs. It applies only the approved editor change
to the reference, through `extendModules`, without editing or activating it.

The final comparison returned zero unexpected differences for all three hosts,
including **identical complete system derivation paths** and identical primary
user Home Manager activation derivations. No blanket store-hash filtering or
package-list sorting is used. Ordered package identities, metadata priorities,
outputs, supported settings, generated scripts, units, and managed files are
also compared to provide useful diagnostics on future regressions. The moved
literal Starship TOML is compared by content.

| Host | Identical system derivation |
|---|---|
| stormbringer | `/nix/store/skvp6s4dmhg886vj25mbym0f6ldir6w3-nixos-system-stormbringer-26.11.20261006.151fa4e.drv` |
| mjolnnir | `/nix/store/2vxkpwhpch75qp0zbrh4a38hj5i96mga-darwin-system-26.11.4cff07d.drv` |
| bifrost | `/nix/store/h5mv3l4nsi461wgwj69wr3wcdqccjkgw-darwin-system-26.11.4cff07d.drv` |

The migration preserved package-list ordering explicitly because changing
module ownership otherwise changed generated profile identities and could
alter collision precedence. It also corrected two default-priority pitfalls:
fish initialization must coexist with upstream hooks, and Steam's Breeze
dependency must coexist with upstream fonts. See `docs/packages.md` for order
priorities and ownership.

## Validation and limits

The following passed without building or activating configurations:

- Parsing changed Nix files and `git diff --check`.
- `nix flake show --all-systems --no-write-lock-file`.
- `nix flake check --all-systems --no-build --no-write-lock-file`, including
  module-contract assertions on both target platforms.
- Eighteen module checks covering real NixOS/nix-darwin imports, Home Manager
  presence/absence, a synthetic import, package disablement, user scope, Eza,
  gaming profiles, browser choice, and explicit overrides.
- Complete system and Home Manager derivation evaluation for each host,
  exercised by the historical comparison.
- Lockfile inspection confirming no surviving input revision changed.

Full JSON comparison reports can be regenerated under `/tmp` using the command
in `AGENTS.md`. The historical reference emits some existing deprecation and
agenix override warnings; these do not come from the migrated configuration.
`nix flake show` labels `darwinConfigurations` as unknown, so it is not a
replacement for explicitly evaluating the Darwin hosts.

Evaluation proves the derivation graph and declared configuration comparison.
It does not prove runtime hardware behavior, external credentials, network
mount availability, or mutable content fetched by Homebrew/browser extensions.
Future input updates are separate work and will intentionally fail historical
derivation equality until their differences are reviewed.
