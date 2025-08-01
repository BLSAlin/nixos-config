{pkgs, ...}: {
  nixpkgs.config = {
    allowUnfree = true;
    rocmSupport = true;
  };

#   programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraPackages = with pkgs; [ kdePackages.breeze ];
  };

   programs.neovim = {
     enable = true;
     viAlias = true;
     vimAlias = true;
     defaultEditor = true;
   };


  hardware.amdgpu.opencl.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    onlyoffice-desktopeditors
    vlc

    # Utilities
    fastfetch
    git
    wget
    zip
    unzip
    file
    tree
    curl
    rclone
    btop
    htop
    bat
    cifs-utils

    # Wayland
    xwayland
    wl-clipboard
    cliphist

    # Other
    home-manager

    # Libs
    rocmPackages.amdsmi
    rocmPackages.rocm-smi
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    font-awesome
    powerline-fonts
  ];
}
