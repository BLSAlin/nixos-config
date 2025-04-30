{ config, ... }: let
    ifEachGroupExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
    user = "andra";
in {
    
    users.users.${user} = {
        isNormalUser = true;
        description = "${user}'s user";
        extraGroups = ifEachGroupExists [
            "audio"
            "networkmanager"
        ];
    };
}
