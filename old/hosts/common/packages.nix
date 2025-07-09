{ pkgs, ... }:

with pkgs; [
  # Basics
  vim
  htop
  btop

  # Internet tools
  wget
  curl
  rclone
  git

  neofetch
  home-manager
]