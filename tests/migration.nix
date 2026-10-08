{
  host ? "stormbringer",
  referenceRevision ? "19ede689f714ba8b302c5544ea566486adb4ecc2",
}:
let
  root = toString ../.;
  current = builtins.getFlake root;
  reference = builtins.getFlake ("git+file://" + root + "?rev=" + referenceRevision);
  lib = current.inputs.nixpkgs.lib;
  family = if host == "stormbringer" then "nixosConfigurations" else "darwinConfigurations";
  # Apply only the approved editor change to the immutable reference.
  expected = reference.${family}.${host}.extendModules {
    modules = [
      (
        { lib, ... }:
        {
          home-manager.users.alin = {
            programs.nixvim.enable = lib.mkForce false;
            programs.nixvim.defaultEditor = lib.mkForce false;
            home.sessionVariables = {
              EDITOR = lib.mkForce "hx";
              VISUAL = lib.mkForce "hx";
            };
            programs.fish.shellAbbrs.vim = lib.mkForce "hx";
          };
        }
        // lib.optionalAttrs (host != "stormbringer") {
          environment.variables.EDITOR = lib.mkForce "hx";
        }
      )
    ];
  };
  manifest = import ./manifest.nix {
    inherit lib;
    inherit (current.inputs) home-manager;
  };
in
{
  inherit host referenceRevision;
  expected = manifest expected;
  actual = manifest current.${family}.${host};
}
