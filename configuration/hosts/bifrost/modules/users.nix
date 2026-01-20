{pkgs, lib, ...}: {
    users.users = {
        alin = {
            uid = 501;
            home = "/Users/alin";
            shell = pkgs.fish;
        };
        andra = {
            uid = 502;
            home = "/Users/andra";
            shell = pkgs.fish;
        };
    };
    users.knownUsers = [
        "alin"
        "andra"
    ];
}