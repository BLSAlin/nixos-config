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

  cfg = globalCfg.pkgs.fish;

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
      programs.fish = {
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

    (lib.mkIf cfg.enable (
      lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isLinux {
          users.defaultUserShell = lib.mkDefault pkgs.fish;
        })
      ]
    ))
  ];
}
