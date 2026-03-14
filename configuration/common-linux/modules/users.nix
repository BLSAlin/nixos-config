{pkgs, lib, user, ...}: let
 keyAsString = path: lib.splitString "\n" (builtins.readFile path);
in {
  programs.fish.enable = true;

  users = {
    defaultUserShell = pkgs.fish;

    users.${user} = {
      isNormalUser = true;
      uid = 1000;
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
    groups.blsfam = { gid = 992; };
    groups.docker = {};
  };
}
