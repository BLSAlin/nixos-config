{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.bls.pkgs.direnv;
  hasDirenv = lib.hasAttrByPath [ "programs" "direnv" "enable" ] options;
in
{
  options.bls.pkgs.direnv.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable preferred direnv configuration.";
  };

  config = lib.optionalAttrs hasDirenv {
    programs.direnv = lib.mkIf cfg.enable {
      enable = cfg.enable;
      nix-direnv.enable = lib.mkDefault true;
    };
  };
}
