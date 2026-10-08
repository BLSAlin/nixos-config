{
  config,
  lib,
  options,
  user,
  ...
}:
let
  support = import ../module-support.nix { inherit lib; };
in
{
  config = lib.mkIf config.bls.pkgs.fish.enable (
    lib.optionalAttrs (support.hasHomeManager options) {
      home-manager.users.${user}.programs.fish = {
        enable = lib.mkDefault true;
        generateCompletions = lib.mkDefault true;
        interactiveShellInit = lib.mkOrder 900 ''
          set fish_greeting
          fish_default_key_bindings
        '';
        shellAbbrs = import ./abbrs.nix { inherit config lib; };
      };
    }
  );
}
