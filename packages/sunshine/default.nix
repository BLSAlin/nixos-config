{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.bls.pkgs.sunshine;
  hasSunshine = lib.hasAttrByPath [ "services" "sunshine" "enable" ] options;
in
{
  options.bls.pkgs.sunshine.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable preferred Sunshine configuration.";
  };

  config = lib.optionalAttrs hasSunshine {
    services.sunshine = lib.mkIf cfg.enable {
      enable = true;
      autoStart = lib.mkDefault true;
      capSysAdmin = lib.mkDefault true;
      openFirewall = lib.mkDefault true;

      applications = lib.mkDefault {
        apps = [
          {
            name = "Steam Big Picture";
            cmd = "xdg-open steam://open/bigpicture";
            auto-detach = "true";
          }
        ];
      };
    };
  };
}
