{ config, pkgs, ... }:
let 
  driveMountPointBase = "/Users/orc";
  driveMountPoint = "${driveMountPointBase}/storage";
in 
{
  launchd.daemons.mount-nas = {
    script = ''
      mkdir -p ${driveMountPoint}

      echo "Attempting mounting the WebDav share under ${driveMountPoint} as $(whoami)"
      mount_webdav https://copyparty.blsalin.dev/downloads ${driveMountPoint}
      echo "Succeded in mounting the WebDav share under ${driveMountPoint} as $(whoami)"

      chmod 770 ${driveMountPoint}
      echo "Changed folder permissions"
    '';
    
    serviceConfig = {
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