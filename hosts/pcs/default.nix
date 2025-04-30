{ config, pkgs, ... }:
{
    imports = [
        ./kdeconnect.nix
    ];

    services = {
        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;

        pipewire = {
            enable = true;
            alsa = {
                enable = true;
                support32Bit = true;
            };
            pulse.enable = true;
        };
    };


    # Install firefox.
    programs.firefox.enable = true;
}
