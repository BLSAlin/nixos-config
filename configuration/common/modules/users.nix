{pkgs, lib, ...}: let
  keyAsString = path: lib.splitString "\n" (builtins.readFile path);
in {
  users = {
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

      openssh.authorizedKeys.keys = keyAsString ../../../pub-keys/alin/key.pub;
    };

    groups.blsfam = {};

  };
}
