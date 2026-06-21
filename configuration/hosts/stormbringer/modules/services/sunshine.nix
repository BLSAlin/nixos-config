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
          name = "Desktop";
          image-path = "desktop.png"; # Sunshine includes a default icon for this
        }
        {
          name = "Steam Big Picture";
          cmd = "xdg-open steam://open/bigpicture";
          auto-detach = "true";
        }
      ];
    };
  };

}
