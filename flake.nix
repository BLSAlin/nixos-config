{
  description = "System configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, nixpkgs-stable, home-manager, ...}@inputs:
    let
      system = "x86_64-linux";
      user = "alin";
      homeStateVersion = "25.05";
      hosts = [
        { hostname = "stormbringer"; stateVersion = "25.05"; }
      ];

      makeSystem = {hostname, stateVersion}: nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            system = system;
            config.allowUnfree = true;
          };

          inherit inputs stateVersion hostname user;
        };

        modules = [
          ./hosts/${hostname}/configuration.nix
        ];
      };

    in {

      nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
        configs // {
          "${host.hostname}" = makeSystem {
            inherit (host) hostname stateVersion;
          };
        }) {} hosts;

      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs homeStateVersion user;
        };

        modules = [
          ./home-manager/home.nix
        ];
      };
    };
}
