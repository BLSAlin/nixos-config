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

    # Others
    microsoft-edge
    spotify
    obs-studio
  ];
}
