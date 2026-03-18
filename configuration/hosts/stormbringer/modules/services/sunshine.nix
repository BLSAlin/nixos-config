{ services, ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      apps = [
        {
          name = "Steam Big Picture";
          cmd = "xdg-open steam://open/bigpicture";
          auto-detach = "true";
        }
      ];
    };
  };

}
