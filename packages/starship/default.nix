{ config, lib, ... }:
let
  isFishEnabled = config.bls.pkgs.fish.enable;
in
{
  imports = [
    ./home-manager.nix
  ];

  options.bls.pkgs.starship.enable = lib.mkOption {
    type = lib.types.bool;
    default = isFishEnabled;
    defaultText = lib.literalExpression "config.bls.pkgs.fish.enable";
    description = "Enable preferred Starship prompt configuration.";
  };
}
