{ pkgs, ... }:
let
  relayConfig = pkgs.writeText "grafana-egress-relay.cfg" ''
    global
      # macOS permits the LAN connection for the root daemon.
      uid 0
      chroot auto
      maxconn 32
      nbthread 1

    defaults
      mode tcp
      timeout connect 4s
      timeout client 60s
      timeout server 60s

    listen grafana-egress
      bind 127.0.0.1:443
      tcp-request inspect-delay 3s
      acl approved_name req.ssl_sni -i authentik.blsalin.dev ntfy.blsalin.dev
      tcp-request content accept if { req.ssl_hello_type 1 } approved_name
      tcp-request content reject if { req.ssl_hello_type 1 } !approved_name
      tcp-request content reject if WAIT_END
      server pi-ingress 10.69.100.11:443
  '';

  # The address is host.lima.internal in Bifrost's default Colima VM.
  composeOverride = pkgs.writeText "grafana-egress-compose.yaml" ''
    services:
      grafana:
        extra_hosts:
          authentik.blsalin.dev: "192.168.5.2"
          ntfy.blsalin.dev: "192.168.5.2"
  '';
in
{
  environment.etc."grafana-egress/relay.cfg".source = relayConfig;
  environment.etc."grafana-egress/compose.yaml".source = composeOverride;

  launchd.daemons.grafana-egress-relay.serviceConfig = {
    Label = "org.nix-darwin.grafana-egress-relay";
    ProgramArguments = [
      "${pkgs.haproxy}/bin/haproxy"
      "-db"
      "-f"
      "${relayConfig}"
    ];
    RunAtLoad = true;
    KeepAlive = true;
    ThrottleInterval = 10;
    ProcessType = "Background";
  };
}
