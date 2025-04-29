{ services, ... }:
{
    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";

            StreamlocalBindUnlink = "yes";
            AcceptEnv = "WAYLAND_DISPLAY";
        };
        openFirewall = true;
    };
}
