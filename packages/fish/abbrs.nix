{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  pkgsConfig = config.bls.pkgs;
  cfg = pkgsConfig.fish;
  isGitEnabled = pkgsConfig.git.enable;

  flakeDir = config.bls.flakeDir;

  hasHomeManager =
    builtins.hasAttr "home-manager" options && builtins.hasAttr "users" options."home-manager";
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
  ];
}
