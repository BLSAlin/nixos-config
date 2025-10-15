{ user, pkgs, ... }: {

  virtualisation.docker = {
    enable = true;

    daemon = {
      ipv6 = true;
      userland-proxy = false;
    };
  };

  users.users.alin.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

}