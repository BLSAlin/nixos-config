{pkgs, lib, ...}: {
    users.users = {
        ${user} = {
            uid = 501;
            home = "/Users/${user}";
            shell = pkgs.fish;
        };
    };
    users.knownUsers = [
        "${user}"
    ];
}