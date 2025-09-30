{ services, ... }:
{
    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";
            StreamlocalBindUnlink = "yes";
        };
        openFirewall = true;
    };
}
