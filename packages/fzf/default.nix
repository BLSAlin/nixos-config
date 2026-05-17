{
  config,
  lib,
  options,
  user,
  ...
}:
let
  cfg = config.bls.pkgs.fzf;
  isFishEnabled = config.bls.pkgs.fish.enable;

  hasHomeManager =
    builtins.hasAttr "home-manager" options && builtins.hasAttr "users" options."home-manager";
in
{
  options.bls.pkgs.fzf.enable = lib.mkOption {
    type = lib.types.bool;
    default = isFishEnabled;
    description = "Enable preferred fzf configuration.";
  };

  config = lib.optionalAttrs hasHomeManager {
    home-manager.users.${user} = {
      programs.fzf = {
        enable = cfg.enable;
        enableFishIntegration = isFishEnabled;
        defaultOptions = lib.mkDefault [ "--layout=reverse" ];
      };
    };
  };
}
