{ services, ... }:
{
    services.openssh.settings.AcceptEnv = "WAYLAND_DISPLAY";
}
