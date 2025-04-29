{ pkgs, config, ... }: let
    ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {

    users.users.alin = {
        isNormalUser = true;
        description = "Alin";
        extraGroups = ifTheyExist
        [
            "audio"
            "git"
            "networkmanager"
            "libvirtd"
            "docker"
            "podman"
            "wheel"
        ];
#         openssh.authorizedKeys = [
#
#         ];
    };

    programs.git = {
        enable = true;
        config = {
            user.name = "Alin Andrei Balasa";
            user.email = "alin.andrei.balasa@blsalin.dev";
        };
    };
}
