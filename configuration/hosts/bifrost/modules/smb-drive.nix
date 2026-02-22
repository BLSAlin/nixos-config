{ config, pkgs, ... }:
let 
  credentialsFilePath = "/Users/orc/.smb_credentials";
  driveMountPoint = "/mnt/remoteBigData";
in 
{
  launchd.daemons.mount-nas = {
    script = ''
      mkdir -p ${driveMountPoint}
      chmod 777 ${driveMountPoint}

      # Source the credentials
      source ${credentialsFilePath}
      
      mount -t smbfs -o noatime,nobrowse smb://$username:$password@10.69.100.11/big-data ${driveMountPoint}
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