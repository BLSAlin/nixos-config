{homeStateVersion, ...}:
{
    imports = [
        ./modules/bundle.nix
    ];

    home = {
        username = "alin";
        homeDirectory = "/home/alin";
        stateVersion = homeStateVersion;
    };
}
