{pkgs, ...}: let 
    extraLinuxPackages = with pkgs; [
      # Utilities
      obs-studio
      ptyxis

      # Browsers
      microsoft-edge
    ];

    extraDarwinPackages = with pkgs; [

    ];

    extraPackages = if pkgs.stdenv.isLinux then extraLinuxPackages else extraDarwinPackages;
  in {
    nixpkgs.config.allowUnfree = true;
    services.kdeconnect.enable = if pkgs.stdenv.isLinux then true else false;

    home.packages = with pkgs; [
      # Development tools
      vscode
      jetbrains.idea-ultimate
      jetbrains.rider

      #Entertaiment
      spotify
      # jellyfin-media-player # Disabled because of CVE on qt5 qtwebengine

      brave
      ungoogled-chromium
    ] ++ extraPackages;
}
