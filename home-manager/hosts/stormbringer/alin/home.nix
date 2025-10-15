{stateVersion, ...}:
{
    imports = [
    ../../../modules/common/default.nix
    ../../../modules/development-cli/default.nix
    ../../../modules/graphical/default.nix
    ../../../modules/gaming/default.nix
    ../../../modules/nixvim/default.nix
    ];

    home = {
        username = "alin";
        homeDirectory = "/home/alin";
        stateVersion = stateVersion;
    };
}
