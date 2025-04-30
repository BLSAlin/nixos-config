{
  description = "Nix customizations spanning NixOs and MacOs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } @inputs: let
    asNames = systemList: map(l: l.fullName) systemList;
    asAttr = systemList: map(l: { system = l; } l) systemList;

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
    # forAllSystems = f: nixpkgs.libs.genAttrs (asNames linuxSystems ++ asNames darwinSystems) f; # TODO NEEDS UPDATING
  in {
    nixosConfigurations = map (fullSystemInformation: 
      {
        ${fullSystemInformation.fullName} = nixpkgs.lib.nixosSystem {
          inherit fullSystemInformation;
          system = fullSystemInformation.fullName;

          specialArgs = inputs;
          modules = [
            ./configuration.nix
          ];
        };
      }
      ) linuxSystems;

# nixosConfigurations = nixpkgs.lib.mergeAttrsList (nixpkgs.lib.genAttrs (asNames linuxSystems) (system:
#       nixpkgs.lib.nixosSystem {
#         inherit system;
#         specialArgs = inputs;
#         modules = [
#           ./configuration.nix
#         ];
#       }
#     )) asAttr linuxSystems;
  };
}
