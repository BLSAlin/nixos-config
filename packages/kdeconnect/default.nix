{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.bls.pkgs.kdeconnect;
  hasFirewall = lib.hasAttrByPath [ "networking" "firewall" "allowedTCPPortRanges" ] options;
in
{
  imports = [
    ./home-manager.nix
  ];

  options.bls.pkgs.kdeconnect.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable preferred KDE Connect configuration.";
  };

  config = lib.optionalAttrs hasFirewall (
    lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isLinux) {
      networking.firewall = {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
      };
    }
  );
}
