{ config, pkgs, ... }:
let 
  credentialsFilePath = "/Users/orc/.smb_credentials";
  driveMountPoint = "/Volumes/remoteBigData";
in 
{
  launchd.daemons.mount-nas = {
    script = ''
      mkdir -p ${driveMountPoint}
      chmod 777 ${driveMountPoint}

      # Source the credentials
      source ${credentialsFilePath}
      
      echo "Attempting mounting the SMB share under ${driveMountPoint}}
      mount -t smbfs -o noatime,nobrowse,-d=777 smb://$username:$password@10.69.100.11/big-data ${driveMountPoint}
    '';
    
    serviceConfig = {
      GroupName = "servicegroup";
      Label = "org.nixos.mount-nas";
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