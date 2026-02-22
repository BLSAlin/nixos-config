{ config, pkgs, ... }:
let 
  driveMountPointBase = "/Users/orc";
  driveMountPoint = "${driveMountPointBase}/storage";
in 
{
  launchd.daemons.mount-nas = {
    script = ''
      mkdir -p ${driveMountPoint}

      echo "Attempting NAS mount"
      ${pkgs.rclone}/bin/rclone mount \
        :webdav,url="https://copyparty.local.blsalin.dev/downloads",vendor="other": ${driveMountPoint} \
        --vfs-cache-mode full \
        --vfs-cache-max-size 5G \
        --dir-cache-time 1m \
        --allow-other \
        --daemon
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