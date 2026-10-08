{
  pkgs,
  lib,
  user,
  ...
}:
{

  users = {

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
    groups.blsfam = {
      gid = 992;
    };
    groups.docker = { };
  };
}
