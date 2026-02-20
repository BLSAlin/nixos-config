{ config, pkgs, ... }:
let 
  mountFolderOrc = "/Users/orc/storage";
in 
{
  # 1. Create the mount point directory
  system.activationScripts.postActivation.text = ''
    mkdir -p ${mountFolderOrc}
    chown orc:staff ${mountFolderOrc}
  '';

  # 2. Define the mount service
  launchd.daemons.mount-nas = {
    script = ''
      # Source the credentials
      source /Users/orc/.smb_credentials
      
      # Unmount if already mounted to avoid 'Resource Busy' errors
      /usr/sbin/diskutil unmount ${mountFolderOrc} || true
      
      # Mount the SMB share
      /sbin/mount_smbfs -N "//$username:$password@10.69.100.11/big-data" ${mountFolderOrc}
    '';
    
    serviceConfig = {
      Label = "org.nixos.mount-nas";
      RunAtLoad = true;
      KeepAlive = {
        NetworkState = true; # Only keep alive if network is up
      };
      StandardOutPath = "/Users/orc/.config/jellyfin/log/mount.log";
      StandardErrorPath = "/Users/orc/.config/jellyfin/log/mount_error.log";
    };
  };
}