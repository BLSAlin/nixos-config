{stateVersion, ...}:
{
    imports = [
    ../../../modules/common
    ../../../modules/development-cli
    ../../../modules/graphical
    ../../../modules/gaming
    ../../../modules/nixvim
    ];

    home = {
        username = "alin";
        homeDirectory = "/home/alin";
        stateVersion = stateVersion;
    };
}
