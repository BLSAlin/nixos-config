{ user, pkgs, ... }: {

  virtualisation.docker = {
    enable = true;

    daemon = {
      ipv6 = false;
      userland-proxy = false;
    };
  };

  users.extraGroups.docker.members = [
    user
    "orc"
  ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

}
