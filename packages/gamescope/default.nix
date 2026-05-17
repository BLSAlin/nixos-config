{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.bls.pkgs.gamescope;
  hasGamescope = lib.hasAttrByPath [ "programs" "gamescope" "enable" ] options;
in
{
  options.bls.pkgs.gamescope.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable preferred Gamescope configuration.";
  };

  config = lib.optionalAttrs hasGamescope {
    programs.gamescope.enable = lib.mkIf cfg.enable true;
  };
}
