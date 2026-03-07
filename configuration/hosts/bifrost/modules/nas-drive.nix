{ config, pkgs, ... }:
let
  driveMountPointBase = "/Users/orc";
  driveMountPoint = "${driveMountPointBase}/storage";
  rcloneConfig = pkgs.writeText "rclone.conf" ''
    [bls_pi_nas]
    type = webdav
    url = https://copyparty.local.blsalin.dev/downloads
    vendor = other
  '';
in
{
  launchd.daemons.mount-nas = {
    script = ''
      export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

      mkdir -p ${driveMountPoint}

      echo "Attempting NAS mount with Nix-generated config"
      ${pkgs.rclone}/bin/rclone mount bls_pi_nas: ${driveMountPoint} \
        --config ${rcloneConfig} \
        -vv \
        --vfs-cache-mode full \
        --vfs-cache-max-size 5G \
        --dir-cache-time 1m \
        --allow-other
      echo "Succeeded in mounting NAS"
    '';

    serviceConfig = {
      UserName = "orc";
      GroupName = "servicegroup";
      Label = "dev.bls.mount-nas";
      RunAtLoad = true;
      KeepAlive = {
        NetworkState = true; # Only keep alive if network is up
      };
      StandardOutPath = "/Users/orc/.config/smb_drive/mount.log";
      StandardErrorPath = "/Users/orc/.config/smb_drive/mount_error.log";
      ProcessType = "Background";
    };
  };
}
