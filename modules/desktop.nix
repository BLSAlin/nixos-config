{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  options.bls.desktop = {
    enable = lib.mkEnableOption "Linux desktop services";
    autoLogin = {
      enable = lib.mkEnableOption "automatic login into the selected desktop";
      user = lib.mkOption {
        type = lib.types.nullOr lib.types.nonEmptyStr;
        default = null;
        description = "Host-specific user to log in automatically; required when autoLogin.enable is true.";
      };
    };
    environment = lib.mkOption {
      type = lib.types.enum [
        "plasma"
        "gnome"
      ];
      default = "plasma";
      description = "Linux desktop environment.";
    };
  };
  config = lib.optionalAttrs (lib.hasAttrByPath [ "boot" "kernelPackages" ] options) (lib.mkMerge [
    {
      assertions = [ {
        assertion = config.bls.desktop.autoLogin.enable -> config.bls.desktop.autoLogin.user != null;
        message = "bls.desktop.autoLogin.enable requires bls.desktop.autoLogin.user to be set explicitly for this host.";
      } ];
    }
    (lib.mkIf config.bls.desktop.enable {
      environment.systemPackages = lib.mkOrder 850 (
        lib.optionals (config.bls.desktop.environment == "plasma") (
          with pkgs;
          [
            kdePackages.kate
            kdePackages.kcalc
          ]
        )
      );
      services.flatpak.enable = lib.mkDefault true;
      services.xserver.enable = lib.mkDefault false;
      services.displayManager.autoLogin = {
        enable = lib.mkDefault config.bls.desktop.autoLogin.enable;
        user = lib.mkDefault config.bls.desktop.autoLogin.user;
      };
      services.displayManager.defaultSession = lib.mkDefault config.bls.desktop.environment;
      services.displayManager.sddm.enable = lib.mkDefault (config.bls.desktop.environment == "plasma");
      services.desktopManager.plasma6.enable = lib.mkDefault (config.bls.desktop.environment == "plasma");
      services.displayManager.gdm.enable = lib.mkDefault (config.bls.desktop.environment == "gnome");
      services.desktopManager.gnome.enable = lib.mkDefault (config.bls.desktop.environment == "gnome");
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
            FastConnectable = true;
          };
          Policy.AutoEnable = true;
        };
      };
      services.blueman.enable = lib.mkDefault (config.bls.desktop.environment == "plasma");
    })
  ]);
}
