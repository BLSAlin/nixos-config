{
  config,
  lib,
  options,
  pkgs,
  user,
  ...
}:
let
  cfg = config.bls.gaming;
  normal = lib.elem cfg.profile [
    "normal"
    "full"
  ];
  support = import ../packages/module-support.nix { inherit lib; };
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
    description = "None, Steam only, gaming applications, or gaming with Sunshine.";
  };
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
    {
      bls.pkgs = {
        gamemode.enable = lib.mkDefault normal;
        gamescope.enable = lib.mkDefault normal;
        steam.enable = lib.mkDefault (cfg.profile != "none");
        sunshine.enable = lib.mkDefault (cfg.profile == "full");
      };
    }
    // lib.optionalAttrs (support.hasHomeManager options) {
      home-manager.users.${user} = { pkgs, ... }: {
        home.packages = lib.mkIf normal (
          lib.mkOrder 600 (
            with pkgs;
            [
              discord
              heroic
              prismlauncher-unwrapped
            ]
          )
        );
      };
    }
  );
}
