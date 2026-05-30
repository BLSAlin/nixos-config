{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bls.pcUse;

  browserPackages = {
    firefox = pkgs.firefox;
    chromium = pkgs.chromium;
  };
in
{
  imports = [
    ../packages/firefox
  ];

  options.bls.pcUse = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable base packages for general PC use.";
    };

    browser = lib.mkOption {
      type = lib.types.enum [
        "firefox"
        "chromium"
      ];
      default = "firefox";
      description = "Browser to install for general PC use.";
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: Add desktop environment setup here once a desktop environment module exists.
    bls.pkgs.firefox.enable = cfg.browser == "firefox";

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [
      browserPackages.${cfg.browser}
      pkgs.spotify
      pkgs.vlc
      pkgs.ptyxis
    ];
  };
}
