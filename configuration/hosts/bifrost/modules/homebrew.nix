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

  launchd.daemons.jellyfin-server = {
      script = ''
        exec /Applications/Jellyfin.app/Contents/MacOS/jellyfin \
          --datadir "/Users/orc/.config/jellyfin/data" \
          --cachedir "/Users/orc/.cache/jellyfin" \
          --configdir "/Users/orc/.config/jellyfin/data/config" \
          --webdir "/Applications/Jellyfin.app/Contents/Resources/jellyfin-web" \
          --logdir "/Users/orc/.config/jellyfin/log"
      '';
      serviceConfig = {
        Label = "dev.bls.jellyfin";
        UserName = "orc";
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/Users/orc/.config/jellyfin/log/stdout.log";
        StandardErrorPath = "/Users/orc/.config/jellyfin/log/stderr.log";
        ProcessType = "Background";
      };
    };
}
