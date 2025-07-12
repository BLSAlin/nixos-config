{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
    # Social
    discord

    # Development
    vscode
    jetbrains.idea-ultimate

    # Games
    heroic
    bottles
    prismlauncher-unwrapped

    # Others
    microsoft-edge
    spotify
    obs-studio
    jellyfin-media-player
  ];
}
