{ user, ... }:
{
  imports = [
    ../../modules
    ../../modules/darwin.nix
    ../primary-user.nix
    ./users.nix
    ./homebrew.nix
  ];
  bls.development.enable = true;
  bls.pcUse.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.controlcenter.BatteryShowPercentage = true;
  home-manager.users.${user}.home.homeDirectory = "/Users/${user}";
}
