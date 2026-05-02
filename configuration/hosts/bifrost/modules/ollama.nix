{ pkgs, ... }:
let
  dataDir = "/Users/orc/.ollama";
  logDir = "/Users/orc/.config/ollama";
in
{
  launchd.daemons.ollama = {
    script = ''
      export PATH="/usr/bin:/bin:/usr/sbin:/sbin"

      mkdir -p "${dataDir}"
      mkdir -p "${logDir}"

      export OLLAMA_HOST=127.0.0.1:11434

      exec ${pkgs.ollama}/bin/ollama serve
    '';

    serviceConfig = {
      Label = "dev.bls.ollama";
      UserName = "orc";
      GroupName = "servicegroup";
      WorkingDirectory = "/Users/orc";
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = "${logDir}/ollama.log";
      StandardErrorPath = "${logDir}/ollama_error.log";
      ProcessType = "Background";
    };
  };
}
