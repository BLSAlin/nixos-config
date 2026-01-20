{stateVersion, ...}:
{
    imports = [
    ../../../modules/common
    ../../../modules/brew
    ../../../modules/development-cli
    ../../../modules/graphical
    ../../../modules/nixvim
    ];

    home = {
        username = "alin";
        homeDirectory = "/Users/alin";
        stateVersion = stateVersion;
    };
}
