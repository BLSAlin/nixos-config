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

  # Media related packages
  ffmpeg
  vlc

  neofetch
  home-manager
]