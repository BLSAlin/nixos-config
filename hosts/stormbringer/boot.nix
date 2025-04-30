{ lib, pkgs, ... }:
{
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
    ];
    loader = {
      grub = {
        enable = true;
        device = "/dev/vda";
        useOSProber = true;
      };
    };
  };

  console = {
    font = "ter-132n";
    packages = [ pkgs.terminus_font ];
    keyMap = "us";
  };

  fonts.packages = [ pkgs.meslo-lgs-nf ];

  services = {
    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        font-name=MesloLGS NF
        font-size=20
      '';
    };
  };
}
