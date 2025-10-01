{stateVersion, ...}:
{
    imports = [
    ../../../modules/fish.nix
    ../../../modules/git.nix
    ../../../modules/packages.nix
    ../../../modules/firefox.nix
    ../../../modules/starship/starship.nix
    ../../../modules/nixvim/bundle.nix
    ];

    home = {
        username = "alin";
        homeDirectory = "/home/alin";
        stateVersion = stateVersion;
    };
}
