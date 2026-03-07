{ config, pkgs, ... }:
let
  driveMountPointBase = "/Users/orc";
  driveMountPoint = "${driveMountPointBase}/storage";
  logDir = "/Users/orc/.config/smb_drive";
  rcloneConfig = pkgs.writeText "rclone.conf" ''
    [bls_pi_nas]
    type = webdav
    url = https://copyparty.local.blsalin.dev/downloads
    vendor = other
  '';
in
{
  launchd.daemons.mount-nas = {
    script = ''
      export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

      RCLONE="${pkgs.rclone}/bin/rclone"
      MOUNT_POINT="${driveMountPoint}"

      cleanup() {
        echo "Cleaning up..."
        pkill -f "rclone mount bls_pi_nas: $MOUNT_POINT" 2>/dev/null || true
        diskutil unmount force "$MOUNT_POINT" 2>/dev/null || true
      }

      trap cleanup EXIT TERM INT

      # Clean up stale mounts/processes from previous runs
      cleanup

      mkdir -p "$MOUNT_POINT"
      mkdir -p ${logDir}

      echo "Starting NAS mount"
      $RCLONE mount bls_pi_nas: "$MOUNT_POINT" \
        --config ${rcloneConfig} \
        -vv \
        --vfs-cache-mode full \
        --vfs-cache-max-size 5G \
        --dir-cache-time 1m \
        --allow-other \
        --uid 499 \
        --gid 499 \
        --timeout 30s \
        --contimeout 30s &
      RCLONE_PID=$!

      echo "rclone started with PID $RCLONE_PID"

      # Health check loop
      while true; do
        sleep 30

        if ! kill -0 "$RCLONE_PID" 2>/dev/null; then
          echo "rclone process died"
          exit 1
        fi

        if ! timeout 10 stat "$MOUNT_POINT" >/dev/null 2>&1; then
          echo "Mount point unresponsive"
          exit 1
        fi
      done
    '';

    serviceConfig = {
      Label = "dev.bls.mount-nas";
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = "${logDir}/mount.log";
      StandardErrorPath = "${logDir}/mount_error.log";
      ProcessType = "Background";
    };
  };
}
