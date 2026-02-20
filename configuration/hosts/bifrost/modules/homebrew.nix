{ ... }: {
  homebrew = {
    enable = true;
    casks = [
      "microsoft-office"
      "rectangle"
      "ghostty"

      "jellyfin"
    ];
  };

  launchd.daemons.jellyfin = {
      serviceConfig = {
      Label = "org.nixos.jellyfin";
      UserName = "orc";
      GroupName = "staff";
      
      ProgramArguments = [
        "/Applications/Jellyfin.app/Contents/MacOS/jellyfin"
        "--datadir" "/Users/orc/.config/jellyfin/data"
        "--cachedir" "/Users/orc/.cache/jellyfin/cache"
        "--configdir" "/Users/orc/.config/jellyfin/config"
        "--logdir" "/Users/orc/.config/jellyfin/log"
        # Point to the web client resources inside the App bundle
        "--webdir" "/Applications/Jellyfin.app/Contents/Resources/jellyfin-web"
        "--noninteractive"
      ];

      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/Users/orc/.config/jellyfin/log/stdout.log";
      StandardErrorPath = "/Users/orc/.config/jellyfin/log/stderr.log";
      ProcessType = "Background";
    };
    };
}
