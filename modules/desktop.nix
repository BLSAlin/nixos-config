{
  config,
  lib,
  options,
  ...
}:
{
  options.bls.desktop = {
    enable = lib.mkEnableOption "Linux desktop services";
    environment = lib.mkOption {
      type = lib.types.enum [
        "plasma"
        "gnome"
      ];
      default = "plasma";
      description = "Linux desktop environment.";
    };
  };
  config = lib.optionalAttrs (lib.hasAttrByPath [ "boot" "kernelPackages" ] options) (
    lib.mkIf config.bls.desktop.enable {
      services.xserver.enable = lib.mkDefault false;
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
      services.blueman.enable = true;
    }
  );
}
