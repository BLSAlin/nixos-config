{ config, pkgs, ... }:
let 
  driveMountPointBase = "/Users/orc";
  driveMountPoint = "${driveMountPointBase}/storage";
in 
{
  launchd.daemons.mount-nas = {
    script = ''
      mkdir -p ${driveMountPoint}

      umount ${driveMountPoint} || true

      chmod 776 ${driveMountPoint}
      
      echo "Attempting mounting the WebDav share under ${driveMountPoint} as $(whoami)"
      mount_webdav https://copyparty.blsalin.dev/downloads ${driveMountPoint}
    '';
    
    serviceConfig = {
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