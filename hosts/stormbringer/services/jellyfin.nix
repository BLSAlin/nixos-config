{ pkgs, lib, ... }: {
  environment.systemPackages =
    with pkgs;
    lib.mkOrder 700 [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
