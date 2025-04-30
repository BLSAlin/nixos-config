{ config, ... }: let
    ifEachGroupExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
    users.users.andra = {
        isNormalUser = true;
        description = "Andra";
        extraGroups = ifEachGroupExists [
            "audio"
            "networkmanager"
        ];
    };
}
