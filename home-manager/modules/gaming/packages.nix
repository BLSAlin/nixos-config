{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Gaming
    gamescope
    gamescope-wsi

    # Social
    discord

    # Games
    heroic
    bottles
    prismlauncher-unwrapped
  ];
}
