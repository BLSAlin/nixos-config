{
  networking.networkmanager.enable = true;

  networking.interfaces.enp10s0.wakeOnLan = {
    enable = true;
    policy = [
      "magic"
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };
}
