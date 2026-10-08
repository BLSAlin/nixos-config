{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  imports = [ ./home-manager.nix ];
  options.bls.pkgs.fish.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.bls.shell.defaultShell == "fish";
    description = "Enable preferred fish configuration.";
  };
  config = lib.mkIf config.bls.pkgs.fish.enable (
    {
      programs.fish.enable = lib.mkDefault true;
    }
    // lib.optionalAttrs (lib.hasAttrByPath [ "users" "defaultUserShell" ] options) {
      users.defaultUserShell = lib.mkOverride 900 pkgs.fish;
    }
  );
}
