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
  config = lib.mkIf config.bls.pkgs.eza.enable (
    lib.optionalAttrs (support.hasHomeManager options) {
      home-manager.users.${user} = { pkgs, ... }: { home.packages = [ pkgs.eza ]; };
    }
  );
}
