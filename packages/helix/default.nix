{ config, lib, ... }:
{
  imports = [ ./home-manager.nix ];
  options.bls.pkgs.helix.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.bls.editor.default == "helix";
    description = "Enable preferred Helix configuration in Home Manager.";
  };
}
