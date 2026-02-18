{pkgs, lib, ...}: {
    users.users = {
        ${user} = {
            uid = 501;
            home = "/Users/${user}";
            shell = pkgs.fish;
        };
        andra = {
            uid = 502;
            home = "/Users/andra";
            shell = pkgs.fish;
        };
    };
    users.knownUsers = [
        "${user}"
        "andra"
    ];
}