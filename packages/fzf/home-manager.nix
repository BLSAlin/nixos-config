{
  config,
  lib,
  options,
  user,
  ...
}:
let
  support = import ../module-support.nix { inherit lib; };
in
{
  config = lib.mkIf config.bls.pkgs.fzf.enable (
    lib.optionalAttrs (support.hasHomeManager options) {
      home-manager.users.${user}.programs.fzf = {
        enable = lib.mkDefault true;
        enableFishIntegration = lib.mkDefault config.bls.pkgs.fish.enable;
        defaultOptions = lib.mkDefault [ "--layout=reverse" ];
      };
    }
  );
}
