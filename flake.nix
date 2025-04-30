{
  description = "Nix customizations spanning NixOs and MacOs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } @inputs: let
    asNames = systemList: map(l: l.fullName) systemList;
    asAttr = systemList: map(l: { system = l; } l) systemList;

    linuxSystems = [ 
      {
        architecture = "x86_64-linux";
        name = "stormbringer";
        owner = "alin";
        fullName = architecture + "_" + name;
      } 
    ];
    darwinSystems = [ 
      {
        architecture = "aarch64-darwin";
        name = "mercury";
      }  
    ];
    forAllSystems = f: nixpkgs.libs.genAttrs (asNames linuxSystems ++ asNames darwinSystems) f;
  in {
    nixosConfigurations = nixpkgs.lib.mergeAttrsList (nixpkgs.lib.genAttrs (asNames linuxSystems) (system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          ./configuration.nix
        ];
      }
    )) asAttr linuxSystems;

  };
}
