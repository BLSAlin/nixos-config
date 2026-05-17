{
  config,
  lib,
  ...
}:
let
  cfg = config.bls.pkgs.kdeconnect;
in
{
  imports = [
    ./home-manager.nix
  ];

  options.bls.pkgs.kdeconnect.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable preferred KDE Connect configuration.";
  };

  config = lib.mkIf cfg.enable { };
}
