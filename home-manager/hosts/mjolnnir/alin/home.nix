{stateVersion, ...}:
{
    imports = [
    ../../../modules/common/bundle.nix
    ../../../modules/development-cli/bundle.nix
    ../../../modules/graphical/bundle.nix
    ../../../modules/nixvim/bundle.nix
    ];

    home = {
        username = "alin";
        homeDirectory = /Users/alin;
        stateVersion = stateVersion;
    };
}
