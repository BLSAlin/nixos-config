{
  inputs ? (builtins.getFlake (toString ../.)).inputs,
}:
let
  lib = inputs.nixpkgs.lib;
  make =
    {
      darwin ? false,
      hm ? false,
      extra ? [ ],
    }:
    let
      constructor = if darwin then inputs.darwin.lib.darwinSystem else lib.nixosSystem;
      hmModule =
        if darwin then
          inputs.home-manager.darwinModules.home-manager
        else
          inputs.home-manager.nixosModules.home-manager;
    in
    (constructor {
      system = if darwin then "aarch64-darwin" else "x86_64-linux";
      specialArgs.user = "alin";
      modules = [
        ../definitions
        ../packages
        {
          system.stateVersion = if darwin then 6 else "25.05";
          nixpkgs.config.allowUnfree = true;
        }
      ]
      ++ lib.optionals hm [
        hmModule
        {
          users.users.alin.home = if darwin then "/Users/alin" else "/home/alin";
          home-manager.users.alin.home = {
            username = "alin";
            homeDirectory = if darwin then "/Users/alin" else "/home/alin";
            stateVersion = "25.05";
          };
        }
      ]
      ++ extra;
    }).config;
  linux = make { };
  darwin = make { darwin = true; };
  linuxHome = make { hm = true; };
  darwinHome = make {
    darwin = true;
    hm = true;
  };
  h = c: c.home-manager.users.alin;
  disabled = make {
    hm = true;
    extra = [
      ({ lib, ... }: {
        bls.pkgs =
          lib.genAttrs
            [
              "fish"
              "fzf"
              "starship"
              "git"
              "helix"
              "tmux"
              "direnv"
              "steam"
              "sunshine"
              "kdeconnect"
            ]
            (_: {
              enable = false;
            });
      })
    ];
  };
  eza = make {
    hm = true;
    extra = [ { bls.pkgs.eza.enable = true; } ];
  };
  profile =
    name:
    make {
      hm = true;
      extra = [
        ../modules/gaming.nix
        { bls.gaming.profile = name; }
      ];
    };
  browser =
    name:
    make {
      hm = true;
      extra = [
        ../modules/pcUse.nix
        {
          bls.pcUse = {
            enable = true;
            browser = name;
          };
        }
      ];
    };
  overridden = make {
    hm = true;
    extra = [
      ../modules/gaming.nix
      ../modules/pcUse.nix
      {
        bls.gaming.profile = "full";
        bls.pkgs.sunshine.enable = false;
        bls.pcUse.enable = true;
        bls.pkgs.firefox.enable = false;
        home-manager.users.alin.programs.tmux.prefix = "C-a";
      }
    ];
  };
  synthetic = lib.evalModules {
    specialArgs = {
      user = "alin";
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    };
    modules = [
      ../definitions
      ../packages/fish
      ({ lib, ... }: {
        options.programs.fish.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      })
    ];
  };
  checks = {
    syntheticFish = synthetic.config.programs.fish.enable;
    plainLinux =
      linux.programs.fish.enable && linux.programs.steam.enable && linux.services.sunshine.enable;
    plainDarwin = darwin.programs.fish.enable && !(darwin ? home-manager);
    homeLinux = (h linuxHome).programs.fish.enable && (h linuxHome).programs.direnv.nix-direnv.enable;
    homeDarwin = (h darwinHome).programs.fish.enable && (h darwinHome).programs.git.enable;
    userEditor =
      (h linuxHome).home.sessionVariables.EDITOR == "hx"
      && (h darwinHome).home.sessionVariables.VISUAL == "hx";
    disabled =
      !(h disabled).programs.fish.enable
      && !(h disabled).programs.fzf.enable
      && !(h disabled).programs.starship.enable
      && !(h disabled).programs.direnv.enable
      && !disabled.programs.steam.enable
      && !disabled.services.sunshine.enable;
    ezaOff = !(linuxHome.bls.pkgs.eza.enable) && (h linuxHome).programs.fish.shellAbbrs.ll == "ls -alh";
    ezaOn = (h eza).programs.fish.shellAbbrs.ll == "eza --icons --group-directories-first -la";
    ezaInstalled = lib.any (p: lib.getName p == "eza") (h eza).home.packages;
    userScope =
      !linuxHome.programs.direnv.enable
      && !(lib.any (p: lib.getName p == "helix") linuxHome.environment.systemPackages);
    gamingNone = !(profile "none").programs.steam.enable && !(profile "none").services.sunshine.enable;
    gamingLite = (profile "lite").programs.steam.enable && !(profile "lite").programs.gamemode.enable;
    gamingNormal =
      (profile "normal").programs.gamemode.enable
      && (profile "normal").programs.gamescope.enable
      && !(profile "normal").services.sunshine.enable;
    gamingFull = (profile "full").services.sunshine.enable;
    firefox = (h (browser "firefox")).programs.firefox.enable;
    chromium = !(h (browser "chromium")).programs.firefox.enable;
    hostOverrides =
      !overridden.services.sunshine.enable
      && !(h overridden).programs.firefox.enable
      && (h overridden).programs.tmux.prefix == "C-a";
  };
in
assert lib.assertMsg (lib.all (v: v) (lib.attrValues checks)) (
  "Failed module checks: "
  + lib.concatStringsSep ", " (lib.attrNames (lib.filterAttrs (_: v: !v) checks))
);
checks
