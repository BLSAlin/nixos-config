{ user, ... }:
{
  imports = [
    ../../modules
    ../../modules/darwin.nix
    ../primary-user.nix
    ./users.nix
    ./service-user.nix
    ./homebrew.nix
    ./services/colima.nix
    ./services/nas-drive.nix
    ./services/ollama.nix
    ./services/jellyfin.nix
  ];
  bls.development.enable = true;
  bls.pcUse.enable = true;
  home-manager.users.${user}.home.homeDirectory = "/Users/${user}";
}
