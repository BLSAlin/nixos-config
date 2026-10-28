{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.bls.pkgs.openssh;
  hasOpenSSH = lib.hasAttrByPath [ "services" "openssh" "settings" ] options;
in
{
  options.bls.pkgs.openssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable preferred OpenSSH configuration on Linux.";
  };

  config = lib.optionalAttrs hasOpenSSH (
    lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isLinux) {
      services.openssh.settings.AcceptEnv = lib.mkDefault [ "WAYLAND_DISPLAY" ];
    }
  );
}
