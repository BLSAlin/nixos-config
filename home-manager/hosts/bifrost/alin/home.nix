{stateVersion, user, ...}:
{
    imports = [
    ../../../modules/common
    ../../../modules/brew
    ../../../modules/development-cli
    ../../../modules/graphical
    ../../../modules/nixvim
    ];

    home = {
        username = "${user}";
        homeDirectory = "/Users/${user}";
        stateVersion = stateVersion;
    };
}
