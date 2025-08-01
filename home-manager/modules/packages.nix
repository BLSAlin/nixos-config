{pkgs, pkgs-stable, ...}: {
  nixpkgs.config.allowUnfree = true;

  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
    # Gaming
    gamescope
    gamescope-wsi

    # Social
    discord

    # Development
    vscode
    jetbrains.idea-ultimate
    jdk17
    jetbrains.rider
    dotnet-sdk_9

    # Games
    heroic
    bottles
    prismlauncher-unwrapped

    # Others
    brave
    spotify
    obs-studio
    jellyfin-media-player
    ptyxis

    ripgrep

    # Fonts
    fira-code
  ] ++ (with pkgs-stable; [

    # Others
    microsoft-edge
  ]);
}
