{pkgs, lib, ...}: let
  keyAsString = path: lib.splitString "\n" (builtins.readFile path);
in {
  users = {
    users.orc = {
      description = "Trusty docker worker account";

      isNormalUser = true;
      extraGroups = [
        "input"
      ];


      openssh.authorizedKeys.keys = keyAsString ../../../pub-keys/orc/key.pub;
    };

    users.knownUsers = [
      "orc"
    ];

  };
}
