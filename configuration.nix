# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
            ./hosts/stormbringer

            ./users/alin
            ./users/andra
        ];


    networking = {
        hostName = lib.mkDefault "nixos-demo";
        networkmanager.enable = true;
    };

    # Set your time zone.
    time.timeZone = "Europe/Bucharest";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_IE.UTF-8";
        LC_IDENTIFICATION = "en_IE.UTF-8";
        LC_MEASUREMENT = "en_IE.UTF-8";
        LC_MONETARY = "en_IE.UTF-8";
        LC_NAME = "en_IE.UTF-8";
        LC_NUMERIC = "en_IE.UTF-8";
        LC_PAPER = "en_IE.UTF-8";
        LC_TELEPHONE = "en_IE.UTF-8";
        LC_TIME = "en_IE.UTF-8";
    };

    services = {
        printing = {
            enable = true;
            drivers = [ pkgs.brlaser ];
        };
    };

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        vim
        wget
        curl
        rclone
        git
        neofetch
        home-manager
    ];

    system.stateVersion = "24.11"; # Did you read the comment?

}
