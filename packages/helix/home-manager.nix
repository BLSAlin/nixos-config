{
  config,
  lib,
  options,
  pkgs,
  user,
  ...
}:
let
  packageSupport = import ../module-support.nix { inherit lib; };

  cfg = config.bls.pkgs.helix;

  hasHomeManager = packageSupport.hasHomeManager options;
in
{
  config = lib.mkIf cfg.enable (
    lib.optionalAttrs hasHomeManager {
      home-manager.users.${user} = { pkgs, ... }: {
        home.sessionVariables = lib.mkIf (config.bls.editor.default == "helix") {
          EDITOR = lib.mkDefault config.bls.editor.command;
          VISUAL = lib.mkDefault config.bls.editor.command;
        };
        programs.helix = {
          enable = lib.mkDefault true;
          settings = lib.mkDefault {
            theme = "ayu_evolve";
          };
          languages.language = lib.mkDefault [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
            }
          ];
        };
      };
    }
  );
}
