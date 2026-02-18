{pkgs, lib, user ...}: let
  keyAsString = path: lib.splitString "\n" (builtins.readFile path);
in {
  programs.fish.enable = true;

  users = {
    defaultUserShell = pkgs.fish;

    users.${user} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "libvirtd"
        "blsfam"
        "docker"
      ];
      home = "/home/${user}";
    };
    groups.blsfam = {};
    groups.docker = {};
  };
}
