{
  config,
  lib,
  options,
  user,
  ...
}:
let
  packageSupport = import ../module-support.nix { inherit lib; };

  cfg = config.bls.pkgs.kdeconnect;

  hasHomeManager = packageSupport.hasHomeManager options;
  useGSConnect =
    lib.attrByPath [ "bls" "desktop" "enable" ] false config
    && lib.attrByPath [ "bls" "desktop" "environment" ] "plasma" config == "gnome";
in
{
  config = lib.mkIf cfg.enable (
    lib.optionalAttrs hasHomeManager {
      home-manager.users.${user} =
        { pkgs, ... }:
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          services.kdeconnect.enable = lib.mkDefault (!useGSConnect);
          home.packages = lib.optional useGSConnect pkgs.gnomeExtensions.gsconnect;
          dconf.settings = lib.mkIf useGSConnect {
            "org/gnome/shell" = {
              disable-user-extensions = lib.mkDefault false;
              enabled-extensions = [ pkgs.gnomeExtensions.gsconnect.extensionUuid ];
            };
          };
        };
    }
  );
}
