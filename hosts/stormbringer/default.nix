{ pkgs, ... }:
{
    imports = [
        ./boot.nix
        ../common
        ../pcs
    ];

    networking.hostName = "stormbringer";

    programs = {
        steam = {
            enable = true;
            remotePlay.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
        };

        gamescope = {
            enable = true;
            capSysNice = true;
        };
    };

    hardware.xone.enable = true;

    environment.systemPackages = with pkgs; [
        kdePackages.kate
        mangohud
        heroic
    ];
}
