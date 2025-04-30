{
  description = "Nix customizations spanning NixOs and MacOs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } @inputs: let
    asNames = systemList: map (l: l.fullName) systemList;
    asAttr = systemList: map (l: { fullSystemInformation = l; } l) systemList;

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
    
    toConfig = fullSystemInformationList:
          map (fullSystemInformation: fullSystemInformation // (nixosSystemFunc fullSystemInformation.fullName)) fullSystemInformationList;
        
    # forAllSystems = f: nixpkgs.libs.genAttrs (asNames linuxSystems ++ asNames darwinSystems) f; # TODO NEEDS UPDATING
  in {

# ["a" "b"] -> {"a" = { ... } "b" = { ... }}
# [{ ... fullName = "a"} {... fullName = "b"}] -> {"a" = { ... } "b" = { ... }}
    nixosConfigurations = toConfig (map asAttr linuxSystems);
    debugLinuxSystems = asAttr linuxSystems;
    inherit linuxSystems;
  };
}
