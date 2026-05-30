{
  config,
  lib,
  ...
}:
let
  cfg = config.bls.pkgs.firefox;
in
{
  imports = [
    ./home-manager.nix
  ];

  options.bls.pkgs.firefox.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable preferred Firefox configuration.";
  };

  config = lib.mkIf cfg.enable { };
}
