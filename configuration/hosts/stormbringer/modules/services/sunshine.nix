{ services, ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      output_name = "DP-2";
    };
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
