{ lib, ... }:
{
  imports = [ ./home-manager.nix ];
  options.bls.pkgs.direnv.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable direnv and nix-direnv for the primary user.";
  };
}
