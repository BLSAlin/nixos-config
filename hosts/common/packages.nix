{ pkgs, ... }:

with pkgs; [
  # Basics
  vim
  htop

  # Internet tools
  wget
  curl
  rclone
  git

  neofetch
  home-manager
]