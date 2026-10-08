{ pkgs, lib, ... }:
{
  nixpkgs.config.rocmSupport = true;

  services.flatpak.enable = true;

  hardware.amdgpu.opencl.enable = true;

  environment.systemPackages =
    with pkgs;
    lib.mkOrder 850 [
      kdePackages.kate
      kdePackages.kcalc

      onlyoffice-desktopeditors
      vlc

      # Libs
      rocmPackages.amdsmi
      rocmPackages.rocm-smi
    ];
}
