{ config, pkgs, ... }:
let 
  
in 
{
  launchd.daemons.mount-nas = {
    script = ''
      # Source the credentials
      source /Users/orc/.smb_credentials
      
      mount -t cifs -o nobrowse smb://$username:$password@10.69.100.11/big-data /Users/orc/storage
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
      ProcessType = "Background";
    };
  };
}