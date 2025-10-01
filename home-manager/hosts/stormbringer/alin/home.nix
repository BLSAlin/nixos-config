{stateVersion, ...}:
{
    imports = [
    ../../../modules/common/bundle.nix
    ../../../modules/development-cli/bundle.nix
    ../../../modules/graphical/bundle.nix
    ../../../modules/gaming/bundle.nix
    ../../../modules/nixvim/bundle.nix
    ];

    home = {
        username = "alin";
        homeDirectory = "/home/alin";
        stateVersion = stateVersion;
    };
}
