{
  description = "System configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
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

    homebrew-steipete-tap = {
      url = "github:steipete/homebrew-tap";
      flake = false;
    };

    ticket = {
      url = "github:BLSAlin/ticket/nix-flake-setup";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      nixpkgs,
      home-manager,
      agenix,
      darwin,
      mac-app-util,
      nix-homebrew,
      ...
    }@inputs:
    let
      user = "alin";

      linuxHosts = [
        {
          hostname = "stormbringer";
          stateVersion = "25.05";
          system = "x86_64-linux";
        }
      ];

      darwinHosts = [
        {
          hostname = "mjolnnir";
          stateVersion = 6;
          homeManagerStateVersion = "25.05";
          system = "aarch64-darwin";
        }
        {
          hostname = "bifrost";
          stateVersion = 6;
          homeManagerStateVersion = "25.05";
          system = "aarch64-darwin";
        }
      ];

      makeLinuxSystem =
        {
          hostname,
          stateVersion,
          system,
        }:
        nixpkgs.lib.nixosSystem {
          system = system;

          specialArgs = {
            inherit
              inputs
              stateVersion
              hostname
              user
              ;
          };

          modules = [
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                users.${user}.home = {
                  username = user;
                  inherit stateVersion;
                };
                extraSpecialArgs = {
                  inherit inputs stateVersion user;
                };
              };
            }
            agenix.nixosModules.default
          ];
        };

      makeDarwinSystem =
        {
          hostname,
          stateVersion,
          homeManagerStateVersion,
          system,
        }:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs // {
            inherit
              inputs
              hostname
              stateVersion
              user
              ;
          };
          modules = [
            mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                users.${user}.home = {
                  username = user;
                  stateVersion = homeManagerStateVersion;
                };
                extraSpecialArgs = {
                  inherit inputs user;
                  stateVersion = homeManagerStateVersion;
                };
                sharedModules = [
                  mac-app-util.homeManagerModules.default
                ];
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
                  "steipete/homebrew-tap" = inputs.homebrew-steipete-tap;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/${hostname}
          ];
        };

    in
    {

      nixosConfigurations = nixpkgs.lib.foldl' (
        configs: host:
        configs
        // {
          "${host.hostname}" = makeLinuxSystem {
            inherit (host) hostname stateVersion system;
          };
        }
      ) { } linuxHosts;

      darwinConfigurations = nixpkgs.lib.foldl' (
        configs: host:
        configs
        // {
          "${host.hostname}" = makeDarwinSystem {
            inherit (host)
              hostname
              stateVersion
              homeManagerStateVersion
              system
              ;
          };
        }
      ) { } darwinHosts;
      checks = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system: {
        module-contracts =
          let
            results = import ./tests/modules.nix { inherit inputs; };
          in
          assert nixpkgs.lib.all (value: value) (nixpkgs.lib.attrValues results);
          nixpkgs.legacyPackages.${system}.runCommand "module-contracts" { } "touch $out";
      });
    };
}
