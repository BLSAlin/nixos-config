{ config, pkgs, ... }:
let
  driveMountPointBase = "/Users/orc";
  driveMountPoint = "${driveMountPointBase}/storage";
in
{
  launchd.daemons.mount-nas = {
    script = ''
      export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

      # Use environment variables for configuration to avoid parsing issues with the URL colon
      export RCLONE_CONFIG_MYNAS_TYPE=webdav
      export RCLONE_CONFIG_MYNAS_URL="https://copyparty.local.blsalin.dev/downloads"
      export RCLONE_CONFIG_MYNAS_VENDOR=other

      mkdir -p ${driveMountPoint}

      echo "Attempting NAS mount"
      ${pkgs.rclone}/bin/rclone mount mynas ${driveMountPoint} \
        -vv \
        --vfs-cache-mode full \
        --vfs-cache-max-size 5G \
        --dir-cache-time 1m \
        --allow-other \
        --fuse-flag user_allow_other
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
