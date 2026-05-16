{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Gaming

    # Social
    discord

    # Games
    heroic
    # bottles
    prismlauncher-unwrapped
  ];

}
