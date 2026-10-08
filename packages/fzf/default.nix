{
  config,
  lib,
  ...
}:
let
  isFishEnabled = config.bls.pkgs.fish.enable;
in
{
  imports = [ ./home-manager.nix ];
  options.bls.pkgs.fzf.enable = lib.mkOption {
    type = lib.types.bool;
    default = isFishEnabled;
    description = "Enable preferred fzf configuration.";
  };

}
