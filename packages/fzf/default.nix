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
in
{
  options.bls.pkgs.fzf.enable = lib.mkOption {
    type = lib.types.bool;
    default = isFishEnabled;
    description = "Enable preferred fzf configuration.";
  };

  programs.fzf = {
    enable = cfg.enable;
    enableFishIntegration = isFishEnabled;
    defaultOptions = lib.mkDefault [ "--layout=reverse" ];
  };
}
