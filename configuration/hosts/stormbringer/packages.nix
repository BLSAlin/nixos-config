{pkgs, ...}: {
  nixpkgs.config.rocmSupport = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraPackages = with pkgs; [ kdePackages.breeze ];
  };

  hardware.amdgpu.opencl.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    onlyoffice-desktopeditors
    vlc

    # Wayland
    xwayland
    wl-clipboard
    cliphist

    # Libs
    rocmPackages.amdsmi
    rocmPackages.rocm-smi
  ];
}
