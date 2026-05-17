{
  config,
  lib,
  options,
  pkgs,
  user,
  ...
}:
let
  globalCfg = config.bls;
  flakeDir = config.bls.flakeDir;
  defaultEditor = config.bls.editor.default;
  editorCommand =
    if defaultEditor == "helix" then
      "hx"
    else
      defaultEditor;

  cfg = globalCfg.pkgs.fish;

  hasHomeManager =
    builtins.hasAttr "home-manager" options && builtins.hasAttr "users" options."home-manager";

  hasFishGenerateCompletions =
    builtins.hasAttr "programs" options
    && builtins.hasAttr "fish" options.programs
    && builtins.hasAttr "generateCompletions" options.programs.fish;
in
{
  options.bls.pkgs.fish.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.bls.shell.defaultShell == "fish";
    defaultText = lib.literalExpression ''config.bls.shell.defaultShell == "fish"'';
    description = "Enable preferred fish shell configuration.";
  };

  imports = [
    ./abbrs.nix
  ];

  config = lib.mkMerge [
    {
      programs.fish =
        {
          enable = cfg.enable;
          interactiveShellInit = lib.mkDefault ''
            set fish_greeting
            fish_default_key_bindings
          '';
        }
        // lib.optionalAttrs hasFishGenerateCompletions {
          generateCompletions = lib.mkDefault true;
        };
    }

    (lib.mkIf cfg.enable (lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isLinux {
        users.defaultUserShell = lib.mkDefault pkgs.fish;
      })

      (lib.optionalAttrs hasHomeManager {
        home-manager.users.${user} = {
          programs.fish = {
            enable = lib.mkDefault true;
            generateCompletions = lib.mkDefault true;

            shellAbbrs = lib.mkDefault {
              ns = "sudo nixos-rebuild switch --flake ${flakeDir}";
              nfu = "nix flake update ${flakeDir}";
              hms = "home-manager switch --flake ${flakeDir}";

              gs = "git status";
              ga = "git add";
              gc = "git commit";
              gp = "git push";
              gpl = "git pull";
              gd = "git diff";
              gl = "git log --oneline --graph";
              gco = "git checkout";
              gb = "git branch";
              gst = "git stash";
              gf = "git fetch";
              gr = "git rebase";

              vim = "nvim";
              grep = "rg";
              cat = "bat";

              ll = "ls -alh";
              ff = "fastfetch";
            };
          };

          home.sessionVariables = {
            EDITOR = lib.mkDefault editorCommand;
            VISUAL = lib.mkDefault editorCommand;
          };
        };
      })
    ]))
  ];
}
