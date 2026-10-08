{ lib, ... }:
{
  imports = [ ./home-manager.nix ];
  options.bls.pkgs.eza.enable = lib.mkEnableOption "Eza and its fish abbreviations";
}
