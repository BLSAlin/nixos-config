{pkgs, ...}:
let
    nasMountPoint = "/Volumes/nas";
in {
  
  launchd.daemons.jellyfin-server = {
      script = ''
        MOUNT_POINT="${nasMountPoint}"
        MAX_WAIT=300
        WAITED=0

        echo "Waiting for NAS mount at $MOUNT_POINT..."
        while ! /usr/bin/find "$MOUNT_POINT" -maxdepth 0 -type d >/dev/null 2>&1; do
          WAITED=$((WAITED + 5))
          if [ "$WAITED" -ge "$MAX_WAIT" ]; then
            echo "NAS mount not available after ''${MAX_WAIT}s, starting Jellyfin anyway"
            break
          fi
          sleep 5
        done
        echo "NAS mount ready (waited ''${WAITED}s)"

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
        WorkingDirectory = "/Users/orc";
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/Users/orc/.config/jellyfin/log/stdout.log";
        StandardErrorPath = "/Users/orc/.config/jellyfin/log/stderr.log";
        ProcessType = "Background";
      };
    };
}
