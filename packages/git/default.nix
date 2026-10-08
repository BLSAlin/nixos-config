{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./home-manager.nix ];
  options.bls.pkgs.git.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable preferred Git configuration.";
  };
  config = lib.mkIf config.bls.pkgs.git.enable {
    environment.systemPackages = lib.mkOrder 810 [ pkgs.git ];
  };
}
