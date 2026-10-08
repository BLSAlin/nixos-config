{
  pkgs,
  lib,
  hostname,
  stateVersion,
  user,
  ...
}:
{
  imports = [
    ../definitions
    ../packages
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "@wheel" ];
  networking.hostName = hostname;
  time.timeZone = "Europe/Bucharest";
  system.stateVersion = stateVersion;
  nixpkgs.config.allowUnfree = true;
  # Keep profile collision precedence stable while packages have separate owners.
  environment.systemPackages =
    with pkgs;
    lib.mkMerge [
      (lib.mkOrder 800 [ fastfetch ])
      (lib.mkOrder 820 [
        wget
        zip
        unzip
        file
        tree
        curl
        rclone
        btop
        htop
        bat
      ])
      (lib.mkOrder 840 [ vim ])
    ];
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
    powerline-fonts
  ];
  home-manager.users.${user} = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    home.packages = lib.mkOrder 650 [ pkgs.fira-code ];
  };
}
