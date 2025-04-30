{
  description = "Nix customizations spanning NixOs and MacOs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } @inputs: let
    linuxSystems = [ 
      {
        architecture = "x86_64-linux";
        name = "stormbringer";
      } 
    ];
    darwinSystems = [ 
      {
        architecture = "aarch64-darwin";
        name = "mercury";
      }  
    ];
    forAllSystems = f: nixpkgs.libs.genAttrs (linuxSystems ++ darwinSystems) f;
  in {
    
    nixosConfigurations = nixpkgs.lib.genAttrs (map linuxSystems (ls: ls.architecture + "_" + ls.name)) (system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          ./configuration.nix
        ];
      }
    );

  };
}
