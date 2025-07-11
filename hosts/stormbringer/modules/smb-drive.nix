{config, ...}: {
  fileSystems."/mnt/remoteBigData" =
    { device = "//10.69.50.11/big-data";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in [ "${automount_opts},credentials=/etc/nixos/smb-remote-big-data-credentials,uid=${toString config.users.users.alin.uid},gid=${toString config.users.groups.blsfam.gid}" ];
    };
}
