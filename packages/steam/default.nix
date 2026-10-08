{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.bls.pkgs.steam;
  hasSteam = lib.hasAttrByPath [ "programs" "steam" "enable" ] options;
in
{
  options.bls.pkgs.steam.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable preferred Steam configuration.";
  };

  config = lib.optionalAttrs hasSteam {
    programs.steam = lib.mkIf cfg.enable {
      enable = true;
      remotePlay.openFirewall = lib.mkDefault true;
      localNetworkGameTransfers.openFirewall = lib.mkDefault true;
      # Upstream also contributes fonts; a mkDefault list would be discarded.
      extraPackages = lib.mkBefore (
        with pkgs;
        [
          kdePackages.breeze
        ]
      );
      extraCompatPackages = lib.mkDefault (
        with pkgs;
        [
          proton-ge-bin
        ]
      );
    };
  };
}
