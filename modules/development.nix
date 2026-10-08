{
  config,
  lib,
  user,
  ...
}:
{
  options.bls.development.enable = lib.mkEnableOption "development tools for the primary user";
  config = lib.mkIf config.bls.development.enable {
    home-manager.users.${user} = import ./development-home.nix;
  };
}
