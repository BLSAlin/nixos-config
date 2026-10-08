{
  config,
  lib,
  options,
  user,
  ...
}:
let
  support = import ../module-support.nix { inherit lib; };
in
{
  config = lib.mkIf config.bls.pkgs.direnv.enable (
    lib.optionalAttrs (support.hasHomeManager options) {
      home-manager.users.${user}.programs.direnv = {
        enable = lib.mkDefault true;
        nix-direnv.enable = lib.mkDefault true;
      };
    }
  );
}
