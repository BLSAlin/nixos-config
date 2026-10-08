{
  config,
  lib,
  options,
  user,
  ...
}:
let
  packageSupport = import ../module-support.nix { inherit lib; };

  cfg = config.bls.pkgs.kdeconnect;

  hasHomeManager = packageSupport.hasHomeManager options;
in
{
  config = lib.mkIf cfg.enable (
    lib.optionalAttrs hasHomeManager {
      home-manager.users.${user} =
        { pkgs, ... }:
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          services.kdeconnect.enable = lib.mkDefault true;
        };
    }
  );
}
