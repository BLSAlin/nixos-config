{ ... }: {
  homebrew = {
    enable = true;
    casks = [
      "microsoft-office"
      "rectangle"
      "ghostty"

      "jellyfin"
    ];

    launchd.user.agents.jellyfin = {
      serviceConfig = {
        Label = "org.nixos.jellyfin";
        # Using the standard Applications path for stability across version updates
        ProgramArguments = [
          "/Applications/Jellyfin.app/Contents/MacOS/jellyfin"
          "--datadir" "/Users/orc/.config/jellyfin/data"
          "--cachedir" "/Users/orc/.cache/jellyfin"
          "--configdir" "/Users/orc/.config/jellyfin"
          "--logdir" "/Users/orc/.config/jellyfin/log"
          "--noninteractive" 
        ];
        RunAtLoad = true;
        KeepAlive = true;
        # Ensures the service waits for the network to be ready
        ProcessType = "Background";
        StandardOutPath = "/Users/orc/.config/jellyfin/log/stdout.log";
        StandardErrorPath = "/Users/orc/.config/jellyfin/log/stderr.log";
      };
    };
}
