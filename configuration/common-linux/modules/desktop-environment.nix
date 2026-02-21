{ config, lib, pkgs, ... }:

let
  cfg = config.blsOptions.desktop;
in {
  options.blsOptions.desktop = {
    enable = lib.mkEnableOption "Desktop Environment Selector";
    
    env = lib.mkOption {
      type = lib.types.enum [ "plasma" "gnome" ];
      default = "none";
      description = "Which desktop environment to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Common X11/Wayland settings
    services.xserver.enable = true;
    services.xserver.libinput.enable = true;

    # Plasma Configuration
    services.displayManager.sddm.enable = lib.mkIf (cfg.env == "plasma") true;
    services.desktopManager.plasma.enable = lib.mkIf (cfg.env == "plasma") true;

    # Gnome Configuration
    services.xserver.displayManager.gdm.enable = lib.mkIf (cfg.env == "gnome") true;
    services.xserver.desktopManager.gnome.enable = lib.mkIf (cfg.env == "gnome") true;
  };
}