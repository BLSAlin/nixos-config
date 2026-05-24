{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bls.gaming;
  enableLite = cfg.profile != "none";
  enableNormal = lib.elem cfg.profile [
    "normal"
    "full"
  ];
in
{
  imports = [
    ../definitions
    ../packages
  ];

  options.bls.gaming.profile = lib.mkOption {
    type = lib.types.enum [
      "none"
      "lite"
      "normal"
      "full"
    ];
    default = "none";
    description = ''
      Gaming package profile. None disables gaming packages, lite enables Steam
      only, normal adds GameMode, Gamescope, and MangoHud, and full also enables
      Sunshine.
    '';
  };

  config = {
    bls.pkgs = {
      gamemode.enable = enableNormal;
      gamescope.enable = enableNormal;
      steam.enable = enableLite;
      sunshine.enable = cfg.profile == "full";
    };

    environment.systemPackages = lib.mkIf enableNormal (
      with pkgs;
      [
        mangohud
      ]
    );
  };
}
