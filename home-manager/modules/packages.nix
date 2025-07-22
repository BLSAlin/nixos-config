{pkgs, pkgs-stable, ...}: {
  nixpkgs.config.allowUnfree = true;

  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
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


    # Fonts
    fira-code
  ] ++ (with pkgs-stable; [

    # Others
    microsoft-edge
  ]);
}
