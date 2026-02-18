{pkgs, ...}: {
  nixpkgs.config.rocmSupport = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraPackages = with pkgs; [ kdePackages.breeze ];
  };

  services.flatpak.enable = true;

  hardware.amdgpu.opencl.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.kcalc

    onlyoffice-desktopeditors
    vlc

    # Libs
    rocmPackages.amdsmi
    rocmPackages.rocm-smi
  ];
}
