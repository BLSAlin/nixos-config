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

#        mangohud = {
#          enable = true;
#          enableSessionWide = true;
#          settings = {
#            frame_timing = false;
#            cpu_stats = true;
#            gpu_stats = true;
#            gpu_temp = true;
#            ram = true;
#            vram = true;
#            hud_compact = true;
#
#            no_display = true;
#
#            toggle_hud = "Shift_L+F1";
#            toggle_hud_position = "Shift_L+F2";
#            reload_cfg = "Shift_L+F3";
#          };
#        };
    };

    hardware.xone.enable = true;

    environment.systemPackages = import ./packages.nix {
        inherit pkgs;
    }++ import ../pcs/packages.nix {
        inherit pkgs;
    };
}
