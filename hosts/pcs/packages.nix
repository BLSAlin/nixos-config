{ pkgs, ... }:
with pkgs; [
  # Document editor
  onlyoffice-desktopeditors

  # Media related packages
  ffmpeg
  vlc
  obs-studio

  # Messaging and chat applications
  discord

  # Entertainment
  spotify

  kdePackages.kdeConnect-kde
]