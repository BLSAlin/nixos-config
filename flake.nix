{
  description = "Nix customizations spanning NixOs and MacOs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } @inputs: let
    asNames = systemList: map (l: l.fullName) systemList;
    asAttr = systemList: map (l: { fullSystemInformation = l; }) systemList;
    toFullNameSet = list: builtins.listToAttrs (map (v: { name = v.fullSystemInformation.fullName; value = v; }) list);

    linuxSystems = [ 
      rec {
        architecture = "x86_64-linux";
        name = "stormbringer";
        owner = "alin";
        fullName = architecture + "_" + name;
      } 
    ];
    darwinSystems = [ 
      rec {
        architecture = "aarch64-darwin";
        name = "mercury";
        fullName = architecture + "_" + name;
      }  
    ];

    nixosSystemFunc = system: nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = inputs;
      modules = [
        ./configuration.nix
      ];
    };
    
    toConfigList = fullSystemInformationList:
            map (fsi: fsi // (nixosSystemFunc fsi.fullSystemInformation.fullName)) fullSystemInformationList;
      

    # forAllSystems = f: nixpkgs.libs.genAttrs (asNames linuxSystems ++ asNames darwinSystems) f; # TODO NEEDS UPDATING
  in {

# ["a" "b"] -> {"a" = { ... } "b" = { ... }}
# [{ ... fullName = "a"} {... fullName = "b"}] -> {"a" = { ... } "b" = { ... }}
    inherit toFullNameSet;
    inherit asNames;
    inherit asAttr;
    inherit linuxSystems;
    inherit toConfigList;
    inherit nixosSystemFunc;

    nixosConfigurations = toFullNameSet (toConfigList (asAttr linuxSystems));
  };
}
