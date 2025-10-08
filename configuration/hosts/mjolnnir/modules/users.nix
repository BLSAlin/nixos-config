{pkgs, lib, ...}: {
    users.users = {
        alin = {
            uid = 501;
            home = "/Users/alin";
            shell = pkgs.fish;
        };
    };
    users.knownUsers = [
        "alin"
    ];
}