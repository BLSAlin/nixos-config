{pkgs, lib, ...}: let
  keyAsString = path: lib.splitString "\n" (builtins.readFile path);
in {
  programs.fish.enable = true;

  users = {
    defaultUserShell = pkgs.fish;

    users.alin = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "libvirtd"
        "blsfam"
        "docker"
      ];
      home = "/home/alin";
    };
    groups.blsfam = {};
    groups.docker = {};
  };
}
