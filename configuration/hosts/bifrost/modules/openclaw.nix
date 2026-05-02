{ pkgs, ... }:
let
  clawhub = pkgs.buildNpmPackage rec {
    pname = "clawhub";
    version = "0.7.0";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/clawhub/-/clawhub-${version}.tgz";
      hash = "sha256-hKCAFLSuifOi2jQqUsDn7liv4u2+PyulYsKXyCizruA=";
    };

    sourceRoot = "package";

    postPatch = ''
      cp ${./clawhub-package-lock.json} package-lock.json
    '';

    npmDepsHash = "sha256-S5cr9c6I2nRqf3BFDo1+he3/MCggAyW4Jo7yutLdIbs=";
    dontNpmBuild = true;
  };

  dataDir = "/Users/orc/.openclaw";
  logDir = "/Users/orc/.config/openclaw";

  sandboxProfile = pkgs.writeText "openclaw-sandbox.sb" ''
    (version 1)
    (deny default)

    ; Process execution
    (allow process-exec)
    (allow process-fork)

    ; Read access (system libs, dyld, binary, etc.)
    (allow file-read*)

    ; Write access — restricted to specific directories
    (allow file-write* (subpath "${dataDir}"))
    (allow file-write* (subpath "${logDir}"))
    (allow file-write* (subpath "/private/tmp"))
    (allow file-write* (subpath "/private/var/folders"))
    (allow file-write* (literal "/dev/null"))

    ; Network
    (allow network-outbound)
    (allow network-bind)
    (allow network-inbound)
    (allow system-socket)

    ; Normal process operation
    (allow sysctl-read)
    (allow mach-lookup)
    (allow signal)
    (allow process-info-pidinfo)
  '';

  caddyfile = pkgs.writeText "Caddyfile" ''
    :8080 {
      @blocked not remote_ip 10.69.100.11 10.69.50.11
      respond @blocked 403

      reverse_proxy 127.0.0.1:18789 {
        health_uri /healthz
        health_interval 30s
      }
    }
  '';
in
{
  environment.systemPackages = [ clawhub ];

  homebrew = {
    taps = [
      "steipete/tap"
    ];
    brews = [
      "steipete/tap/gogcli"
      "gemini-cli"
    ];
    casks = [
      "1password-cli"
      "claude-code"
    ];
  };

  launchd.daemons.openclaw = {
    script = ''
      export PATH="/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"

      mkdir -p "${dataDir}"
      mkdir -p "${logDir}"

      export OPENCLAW_GATEWAY_BIND=loopback
      export OPENCLAW_SANDBOX=macossandbox

      exec /usr/bin/sandbox-exec -f ${sandboxProfile} /opt/homebrew/bin/openclaw gateway
    '';

    serviceConfig = {
      Label = "dev.bls.openclaw";
      UserName = "orc";
      GroupName = "servicegroup";
      WorkingDirectory = dataDir;
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = "${logDir}/openclaw.log";
      StandardErrorPath = "${logDir}/openclaw_error.log";
      ProcessType = "Background";
    };
  };

  launchd.daemons.openclaw-caddy = {
    script = ''
      export PATH="/usr/bin:/bin:/usr/sbin:/sbin"

      mkdir -p "${logDir}"

      # Wait for OpenClaw to become healthy
      MAX_WAIT=120
      WAITED=0

      echo "Waiting for OpenClaw at http://127.0.0.1:18789/healthz..."
      while ! curl -sf http://127.0.0.1:18789/healthz >/dev/null 2>&1; do
        WAITED=$((WAITED + 5))
        if [ "$WAITED" -ge "$MAX_WAIT" ]; then
          echo "OpenClaw not healthy after ''${MAX_WAIT}s, starting Caddy anyway"
          break
        fi
        sleep 5
      done
      echo "OpenClaw ready (waited ''${WAITED}s)"

      ${pkgs.caddy}/bin/caddy run --config ${caddyfile} --adapter caddyfile &
      CADDY_PID=$!
      echo "Caddy started with PID $CADDY_PID"

      cleanup() {
        echo "Stopping Caddy..."
        kill "$CADDY_PID" 2>/dev/null || true
        wait "$CADDY_PID" 2>/dev/null || true
      }

      trap cleanup EXIT TERM INT

      while true; do
        sleep 30
        if ! kill -0 "$CADDY_PID" 2>/dev/null; then
          echo "Caddy process died"
          exit 1
        fi
      done
    '';

    serviceConfig = {
      Label = "dev.bls.openclaw-caddy";
      UserName = "orc";
      GroupName = "servicegroup";
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = "${logDir}/caddy.log";
      StandardErrorPath = "${logDir}/caddy_error.log";
      ProcessType = "Background";
    };
  };
}
