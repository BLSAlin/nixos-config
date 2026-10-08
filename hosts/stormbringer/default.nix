{ pkgs, user, ... }:
{
  imports = [
    ../../modules
    ../../modules/linux.nix
    ../primary-user.nix
    ./hardware-configuration.nix
    ./users.nix
    ./networking.nix
    ./packages.nix
    ./printing.nix
    ./virtmanager.nix
    ./xone.nix
    ./smb-drive.nix
    ./openssh.nix
    ./services/jellyfin.nix
    ./services/dslr-camera.nix
  ];
  bls.development.enable = true;
  bls.pcUse.enable = true;
  bls.desktop.enable = true;
  bls.gaming.profile = "full";
  programs.nix-ld.enable = true;
  services.sunshine.settings.output_name = "DP-2";
  home-manager.users.${user}.home.homeDirectory = "/home/${user}";
}
