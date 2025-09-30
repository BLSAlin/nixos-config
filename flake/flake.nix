{
  description = "System configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

  };

  outputs = {nixpkgs, nixpkgs-unstable, home-manager, firefox-addons, nixvim, agenix, ...}@inputs:
    let
      system = "x86_64-linux";
      user = "alin";
      homeStateVersion = "25.05";
      hosts = [
        { hostname = "stormbringer"; stateVersion = "25.05"; system = "x86_64-linux"; }
      ];

      makeSystem = {hostname, stateVersion, system}: nixpkgs.lib.nixosSystem {
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
          agenix.nixosModules.default
        ];
      };

    in {

      nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
        configs // {
          "${host.hostname}" = makeSystem {
            inherit (host) hostname stateVersion system;
          };
        }) {} hosts;

      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs homeStateVersion user;

          pkgs-stable = import nixpkgs {
            system = system;
            config.allowUnfree = true;
          };

          firefox-addons = firefox-addons.packages.${system};
        };

        modules = [
          ./home-manager/home.nix
        ];
      };
    };
}
