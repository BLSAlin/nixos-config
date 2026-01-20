{ pkgs, ...}: 
let
  colimaPath = "/Users/orc/colima";
in
{
  environment.systemPackages = [
    docker
    docker-compose
    
    colima
  ];

  launchd.daemons.colima-orc = {
    script = ''
      # Isolate Colima state to the dedicated subfolder
      export HOME="${colimaPath}"
      export PATH="${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
      
      # Clean up existing socket if a crash occurred to ensure a clean start
      rm -rf "${colimaPath}/.colima/default/docker.sock"

      exec ${pkgs.colima}/bin/colima start --foreground \
        --vm-type=vz \
        --mount-type=virtiofs \
        --cpu 4 \
        --memory 8 \
        --disk 100 \
        --arch aarch64
    '';

    serviceConfig = {
      Label = "org.nix-darwin.colima-orc";
      UserName = "orc";
      GroupName = "staff";
      RunAtLoad = true;
      KeepAlive = true;
      WorkingDirectory = colimaPath;
      # Logs are vital for a headless server
      StandardOutPath = "/var/log/colima-orc.log";
      StandardErrorPath = "/var/log/colima-orc.error.log";
    };
  };
}