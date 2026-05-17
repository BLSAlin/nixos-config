{
  config,
  lib,
  options,
  user,
  ...
}:
let
  packageSupport = import ../module-support.nix { inherit lib; };

  cfg = config.bls.pkgs.vscode;

  hasHomeManager = packageSupport.hasHomeManager options;
in
{
  config = lib.mkIf cfg.enable (
    lib.optionalAttrs hasHomeManager {
      home-manager.users.${user}.programs.vscode = {
        enable = cfg.enable;
      };
    }
  );
}
