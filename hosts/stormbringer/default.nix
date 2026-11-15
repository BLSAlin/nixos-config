{ pkgs, user, ... }:
{
  imports = [
    ../../modules
    ../../modules/linux.nix
    ../primary-user.nix
    ./hardware-configuration.nix
    ./users.nix
    ./smb-drive.nix
  ];
  bls.pkgs.hardware.dslrCamera = {
    enable = true;
    usbVendorId = "04a9";
    usbProductId = "32d9";
  };
  bls.pkgs.hardware.amdGpu.enable = true;
  bls.development.enable = true;
  bls.pcUse.enable = true;
  bls.desktop.enable = true;
  bls.printing = {
    enable = true;
    drivers = [ "brother" ];
  };
  bls.virtualization.enabled = true;
  bls.gaming.profile = "full";
  bls.pkgs.sunshine.enable = false;
  programs.nix-ld.enable = true;
  services.sunshine.settings.output_name = "DP-2";
  home-manager.users.${user}.home.homeDirectory = "/home/${user}";

  # Test an idle GPU hang workaround: clear GFXOFF (0x8000) from the observed
  # default mask (0xfff7bfff), preserving the other power-management features.
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xfff73fff" ];

  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=DE
  '';
}
