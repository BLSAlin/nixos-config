{ ... }: {
  homebrew = {
    enable = true;
    casks = [
      "microsoft-office"
      "rectangle"
      "ghostty"

      "jellyfin"
    ];

    launchd.daemons.jellyfin = {
      script = ''
        # We use the full path to the internal binary of the Cask
        exec /Applications/Jellyfin.app/Contents/MacOS/jellyfin \
          --datadir "/Users/orc/.config/jellyfin/data" \
          --cachedir "/Users/orc/.cache/jellyfin" \
          --configdir "/Users/orc/.config/jellyfin" \
          --logdir "/Users/orc/.config/jellyfin/log" \
          --noninteractive
      '';
      serviceConfig = {
        Label = "org.nixos.jellyfin";
        # THIS IS THE KEY: It tells launchd to drop privileges to 'orc'
        UserName = "orc";
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/Users/orc/.config/jellyfin/log/stdout.log";
        StandardErrorPath = "/Users/orc/.config/jellyfin/log/stderr.log";
      };
    };
  }
}
