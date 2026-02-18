{pkgs, lib, user, ...}: let
  keyAsString = path: lib.splitString "\n" (builtins.readFile path);
in {
  users = {
    users.${user} = {
      description = "Alin Andrei Balasa";

      openssh.authorizedKeys.keys = keyAsString ../../../pub-keys/${user}/key.pub;
    };

  };
}
