{
  description = "Nix customizations spanning NixOs and MacOs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } @inputs: let
    linuxSystems = [ "x86_64-linux" ];
    darwinSystems = [ "x86_64-darwin" ];
    forAllSystems = f: nixpkgs.libs.genAttrs (linuxSystems ++ darwinSystems) f;
  in {
    
    nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system:
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
