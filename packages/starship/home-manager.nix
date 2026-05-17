{
  config,
  lib,
  options,
  user,
  ...
}:
let
  packageSupport = import ../module-support.nix { inherit lib; };

  cfg = config.bls.pkgs.starship;
  isFishEnabled = config.bls.pkgs.fish.enable;

  hasHomeManager = packageSupport.hasHomeManager options;
in
{
  config = lib.mkIf cfg.enable (
    lib.optionalAttrs hasHomeManager {
      home-manager.users.${user} = {
        programs.starship = {
          enable = lib.mkDefault true;
          enableFishIntegration = lib.mkDefault isFishEnabled;
        };

        xdg.configFile."starship.toml".source = ./starship.toml;
      };
    }
  );
}
