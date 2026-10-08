{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  packageSupport = import ../module-support.nix { inherit lib; };

  pkgsConfig = config.bls.pkgs;
  cfg = pkgsConfig.fish;
  isGitEnabled = pkgsConfig.git.enable;
  isEzaAvailable = pkgsConfig.eza.enable;

  flakeDir = config.bls.flakeDir;

  hasHomeManager = packageSupport.hasHomeManager options;
in
{
  config = lib.mkMerge [
    {
      programs.fish.shellAbbrs = {
        ns = "sudo nixos-rebuild switch --flake ${flakeDir}";
        nfu = "nix flake update ${flakeDir}";

        ll = "ls -alh";
      };
    }

    (lib.mkIf isGitEnabled {
      programs.fish.shellAbbrs = {
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gpl = "git pull";
        gd = "git diff";
        gl = "git log --oneline --graph";
        gco = "git checkout";
        gb = "git branch";
        gst = "git stash";
        gf = "git fetch";
        gr = "git rebase";
      };
    })

    (lib.mkIf hasHomeManager {
      programs.fish.shellAbbrs = {
        hms = "home-manager switch --flake ${flakeDir}";
      };
    })

    (lib.mkIf isEzaAvailable {
      programs.fish.shellAbbrs = {
        ls = "eza --icons -group-directories-first";
        ll = "eza --icons --group-directories-first -la";
      };
    })
  ];
}
