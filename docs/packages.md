# Package Layer Decisions

The package layer is active on all three hosts. It contains curated Nix
configuration modules, not package derivations.

## Structure and ownership

All custom options use `bls.*`. Package enablement is
`bls.pkgs.<name>.enable`; native upstream options configure exceptions.
Shared preferences live in `definitions/`. The package aggregator imports
direct child directories containing `default.nix`.

Package-specific user settings live in `packages/<name>/home-manager.nix`.
They target the parametrized primary `user`, and omit their entire
Home Manager branch when its options are absent. Multi-user Home Manager
support remains out of scope. Use Home Manager's own `pkgs` for user
packages so system overlays do not silently change their derivations.

Automatic defaults are intentional. Importing the package aggregator on Linux
can enable Steam and Sunshine. Host profiles may override these defaults;
importing modules is not a passive declaration-only operation.

## Defaults and scope

| Package | Enable default | Ownership |
|---|---|---|
| fish | Selected shell is fish | System shell support; user initialization and abbreviations |
| fzf | Fish enabled | Home Manager, fish integration follows fish |
| starship | Fish enabled | Home Manager, unchanged TOML |
| git | true | System Git; user identity, credentials, gh, forgejo-cli, credential manager |
| helix | Selected editor is Helix | Home Manager only, ayu_evolve theme and Nix formatter |
| tmux | true | Existing system installation and user configuration |
| direnv | true | Home Manager only, including nix-direnv |
| firefox | false | Home Manager policies, search engines, extensions |
| vscode | false | Home Manager |
| kdeconnect | true | Home Manager service on Linux only |
| steam | true | Native Linux module, firewall rules, Breeze, Proton-GE |
| sunshine | true | Native Linux service, Desktop and Steam Big Picture entries |
| gamemode | false | Native Linux module |
| gamescope | false | Native Linux module |
| eza | false | Optional user package and fish ls/ll abbreviations |

`bls.shell.defaultShell` is fish. `bls.editor.default` is Helix;
`bls.editor.choices.helix.command` is `hx`. Helix sets user EDITOR/VISUAL;
Darwin's existing system EDITOR setting also becomes hx. Nixvim and its
language-server setup are removed. Standalone Vim remains installed.

Fish keeps the legacy ns/nfu/hms abbreviations as text; validation never runs
them. The hms abbreviation does not correspond to a standalone flake output.
The unfinished gf/gr additions were not part of the active baseline and are
not enabled. Eza's integration is retained, corrected, and disabled by default.

## Profiles

- `bls.development.enable`: existing user development inventory, including ticket.
- `bls.pcUse.enable`: graphical user inventory and VS Code;
  `bls.pcUse.browser` selects Firefox or Chromium. Existing companion browsers
  remain installed. Linux-only applications remain platform-guarded.
- `bls.desktop.enable`: Linux display, sound, and Bluetooth services;
  `bls.desktop.environment` defaults to plasma and also supports gnome.
- `bls.gaming.profile`: none disables gaming defaults on Linux; lite enables
  Steam; normal adds GameMode, Gamescope, Discord, Heroic, and Prism Launcher;
  full also enables Sunshine. It does not add Bottles or MangoHud.

All current hosts select development and graphical use. Stormbringer selects
Plasma and full gaming. Higher-level profiles assume integrated Home Manager;
individual package modules also evaluate without it.

Breeze and KDE Connect keep their historical defaults even when selecting a
different desktop. Native options can override them; introducing automatic
desktop-dependent behavior is a separate choice.

## Merge and ordering rules

Use `mkDefault` for overridable scalar preferences. Additive native lists and
shell hooks require ordinary definitions with explicit ordering, because
`mkDefault` would discard them when upstream contributes at normal priority.
Steam's Breeze list and fish's initialization are examples.

Explicit package list ordering preserves the baseline's collision precedence
and generated profile identities despite moving definitions between modules:

- User packages: gaming 600, graphical 610, Git companions 620, runtimes 630,
  credential manager 635, remaining development tools 640, font 650.
- System packages: host service tools 700, fastfetch 800, Git 810, utilities 820,
  tmux 830, Vim 840, Linux host applications 850. Upstream module contributions
  retain their normal order.
- Fish initialization uses order 900, after fzf and before normal upstream hooks.

These are list order priorities, not package metadata priorities. Do not
replace them with sorting or `mkForce`: either could change collision behavior.
Fish's default system shell uses override priority 900 to beat upstream Bash's
default while leaving ordinary host definitions effective.

## Validation

See [AGENTS.md](../AGENTS.md) for evaluation-only commands and
[migration.md](migration.md) for the baseline and comparison coverage.
Keep input updates separate from configuration refactors.
