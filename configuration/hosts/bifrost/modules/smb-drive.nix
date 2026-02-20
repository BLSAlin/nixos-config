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
      
      # Determine IDs dynamically if you don't want to hardcode
      ORC_UID=$(id -u orc)
      ORC_GID=$(id -g orc)

      /usr/sbin/diskutil unmount ${mountFolderOrc}} || true
      
      /sbin/mount_smbfs -N \
        -u "$ORC_UID" \
        -g "$ORC_GID" \
        -f 0700 \
        -d 0700 \
        "//$username:$password@10.69.100.11/big-data" ${mountFolderOrc}
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