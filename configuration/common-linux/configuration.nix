# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, hostname, stateVersion, ... }:
{
  imports =
    [
        ../common/configuration.nix
        ./modules/bundle.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_16;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}