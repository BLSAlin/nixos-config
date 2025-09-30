{pkgs, lib, ...}: let
  keyAsString = path: lib.splitString "\n" (builtins.readFile path);
in {
  programs.fish.enable = true;

  users = {
    defaultUserShell = pkgs.fish;

    users.alin = {
      isNormalUser = true;
      description = "Alin Andrei Balasa";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "libvirtd"
        "blsfam"
      ];

      openssh.authorizedKeys.keys = keyAsString ../../../pub_keys/alin/key.pub;
    };

    groups.blsfam = {};

  };
}
