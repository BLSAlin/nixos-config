{ stateVersion, ...}:
{
  imports = [
    ../../../modules/common
    ../../../modules/brew
    ../../../modules/graphical
    
    ./packages.nix
    ];

    home = {
        username = "andra";
        homeDirectory = "/Users/andra";
        stateVersion = stateVersion;
    };
}