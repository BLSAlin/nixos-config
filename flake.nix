{
  description = "System configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };


    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

  };

  outputs = {nixpkgs, home-manager, firefox-addons, nixvim, agenix, darwin, nix-homebrew, ...}@inputs:
    let
      user = "alin";

      linuxHosts = [
        { hostname = "stormbringer"; stateVersion = "25.05"; system = "x86_64-linux"; }
      ];

      darwinHosts = [
        { hostname = "mjolnnir"; stateVersion = 6; homeManagerStateVersion = "25.05"; system = "aarch64-darwin"; }
      ];

      allHosts = linuxHosts // darwinHosts;


      makeLinuxSystem = {hostname, stateVersion, system}: nixpkgs.lib.nixosSystem {
        system = system;

        specialArgs = {
          inherit inputs stateVersion hostname user;
        };

        modules = [
          ./configuration/hosts/${hostname}/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.${user} = ./home-manager/hosts/${hostname}/${user}/home.nix;
              extraSpecialArgs = {
                inherit inputs stateVersion user;

                firefox-addons = firefox-addons.packages.${system};
              };
            };
          }

          agenix.nixosModules.default
        ];
      };


      makeDarwinSystem = {hostname, stateVersion, homeManagerStateVersion, system}: darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs // { inherit stateVersion user; };
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              users.${user} = ./home-manager/hosts/${hostname}/${user}/home.nix;
              extraSpecialArgs = {
                inherit inputs user;
                stateVersion = homeManagerStateVersion;

                firefox-addons = firefox-addons.packages.${system};
              };
            };
          }

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              inherit user;
              enable = true;

              enableRosetta = true;

              taps = {
                "homebrew/homebrew-core" = inputs.homebrew-core;
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
              };
              mutableTaps = false;
              autoMigrate = true;
            };
          }
          ./configuration/hosts/${hostname}/configuration.nix
        ];
      };

    in {

      nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
        configs // {
          "${host.hostname}" = makeLinuxSystem {
            inherit (host) hostname stateVersion system;
          };
        }) {} linuxHosts;


      darwinConfigurations = nixpkgs.lib.foldl' (configs: host:
        configs // {
          "${host.hostname}" = makeDarwinSystem {
            inherit (host) hostname stateVersion homeManagerStateVersion system;
          };
        }) {} darwinHosts;
    };
}
