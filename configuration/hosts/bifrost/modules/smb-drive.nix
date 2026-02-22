{ config, pkgs, ... }:
let 
  credentialsFilePath = "/Users/orc/.smb_credentials";
  driveMountPoint = "/Volumes/remoteBigData";
in 
{
  launchd.daemons.mount-nas = {
    script = ''
      echo "Initial status of mount point"
      ls -al /Volumes || true

      mkdir -p ${driveMountPoint}
      echo "Status of mount point after mkdir"
      ls -al /Volumes || true

      chmod 776 ${driveMountPoint}
      echo "Status of mount point after chmod"
      ls -al /Volumes || true


      # Source the credentials
      source ${credentialsFilePath}
      
      echo "Attempting mounting the SMB share under ${driveMountPoint} as $(whoami)"
      mount_smbfs -o nosuid,noatime,nobrowse -d777 -f776 smb://$username:$password@10.69.100.11/big-data ${driveMountPoint}
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