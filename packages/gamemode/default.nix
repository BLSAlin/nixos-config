{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.bls.pkgs.gamemode;
  hasGameMode = lib.hasAttrByPath [ "programs" "gamemode" "enable" ] options;
in
{
  options.bls.pkgs.gamemode.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable preferred GameMode configuration.";
  };

  config = lib.optionalAttrs hasGameMode {
    programs.gamemode.enable = lib.mkIf cfg.enable true;
  };
}
