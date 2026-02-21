{ config, pkgs, ... }:
let 
  mountFolderOrc = "/Users/orc/storage";
in 
{
  # 1. Create the mount point directory
  system.activationScripts.postActivation.text = ''
    mkdir -p ${mountFolderOrc}
  '';

  # 2. Define the mount service
  launchd.daemons.mount-nas = {
    script = ''
      # Source the credentials
      source /Users/orc/.smb_credentials

      /usr/sbin/diskutil unmount ${mountFolderOrc}} || true
      
      /sbin/mount_smbfs -N \
        -f 0700 \
        -d 0700 \
        -o nodev,nosuid,noatime,nolocalcaches \
        "//$username:$password@10.69.100.11/big-data" ${mountFolderOrc}
    '';
    
    serviceConfig = {
      UserName = "orc";
      GroupName = "servicegroup";
      Label = "org.nixos.mount-nas";
      RunAtLoad = true;
      KeepAlive = {
        NetworkState = true; # Only keep alive if network is up
      };
      StandardOutPath = "/Users/orc/.config/smb_drive/mount.log";
      StandardErrorPath = "/Users/orc/.config/smb_drive/mount_error.log";
    };
  };
}