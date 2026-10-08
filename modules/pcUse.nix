{
  config,
  lib,
  user,
  ...
}:
{
  imports = [
    ../definitions
    ../packages
  ];
  options.bls.pcUse = {
    enable = lib.mkEnableOption "general graphical applications";
    browser = lib.mkOption {
      type = lib.types.enum [
        "firefox"
        "chromium"
      ];
      default = "firefox";
      description = "Preferred browser; existing companion browsers remain installed.";
    };
  };
  config = lib.mkIf config.bls.pcUse.enable {
    bls.pkgs.firefox.enable = lib.mkDefault (config.bls.pcUse.browser == "firefox");
    bls.pkgs.vscode.enable = lib.mkDefault true;
    home-manager.users.${user} = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      home.packages =
        with pkgs;
        lib.mkOrder 610 (
          [
            jetbrains.idea
            spotify
            brave
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            obs-studio
            ptyxis
            wl-clipboard
            ungoogled-chromium
            unityhub
          ]
          ++ lib.optional (config.bls.pcUse.browser == "chromium") chromium
        );
    };
  };
}
