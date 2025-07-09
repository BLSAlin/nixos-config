{ config, pkgs, ... }:
{
    imports = [
        ./kdeconnect.nix
    ];

    services = {
        # Enable SDDM and Plasma 6
        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;

        # Enable sound with pipewire.
        pipewire = {
            enable = true;
            alsa = {
                enable = true;
                support32Bit = true;
            };
            pulse.enable = true;
        };

        # Enable printing support
        printing = {
            enable = true;
            drivers = [ pkgs.brlaser ];
        };


    };

    # Install firefox.
    programs.firefox.enable = true;
}
