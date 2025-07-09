# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
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

    security.rtkit.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;


    environment.systemPackages = with pkgs; [
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
        # home-manager
    ];

    environment.variables.EDITOR = "vim";

    system.stateVersion = "24.11"; # Did you read the comment?



# TODO REMOVE ONCE CLEANED UP
    users.users.alin = {
        isNormalUser = true;
        description = "Alin";
        extraGroups =
        [
            "audio"
            "git"
            "networkmanager"
            "libvirtd"
            "docker"
            "podman"
            "wheel"
        ];
        openssh.authorizedKeys.keys = keyAsString ./home/alin/.ssh/alin_key.pub;
    };

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";

            StreamlocalBindUnlink = "yes";
            AcceptEnv = "WAYLAND_DISPLAY";
        };
        openFirewall = true;
    };
}
