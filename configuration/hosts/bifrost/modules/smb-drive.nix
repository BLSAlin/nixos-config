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
      
      echo "Attempting mounting the SMB share under ${driveMountPoint} as $(whoami)"
      mount_smbfs -o noatime,nobrowse -d777 -f776 smb://copyparty.blsalin.dev/downloads ${driveMountPoint}
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