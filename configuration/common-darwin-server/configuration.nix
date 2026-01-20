{ config, pkgs, lib, hostname, stateVersion, ... }:
{
  imports =
    [
        ../common/configuration.nix
        ./modules/default.nix
    ];
}