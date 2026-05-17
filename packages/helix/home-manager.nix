{
  config,
  lib,
  options,
  pkgs,
  user,
  ...
}:
let
  cfg = config.bls.pkgs.helix;

  hasHomeManager =
    builtins.hasAttr "home-manager" options && builtins.hasAttr "users" options."home-manager";
in
{
  config = lib.mkIf cfg.enable (
    lib.optionalAttrs hasHomeManager {
      home-manager.users.${user}.programs.helix = {
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
    }
  );
}
