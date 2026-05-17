{
  config,
  lib,
  options,
  user,
  ...
}:
let
  packageSupport = import ../module-support.nix { inherit lib; };

  cfg = config.bls.pkgs.fzf;
  isFishEnabled = config.bls.pkgs.fish.enable;

  hasHomeManager = packageSupport.hasHomeManager options;
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
