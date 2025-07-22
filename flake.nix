{
  description = "System configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};
  };

  outputs = {nixpkgs, nixpkgs-unstable, home-manager, firefox-addons, ...}@inputs:
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
          pkgs-unstable = import nixpkgs-unstable {
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
        pkgs = nixpkgs-unstable.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs homeStateVersion user;
          firefox-addons = firefox-addons.packages.${system};
        };
        pkgs-stable = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };

        modules = [
          ./home-manager/home.nix
        ];
      };
    };
}
