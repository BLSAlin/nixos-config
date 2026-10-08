{ config, lib }:
let
  flakeDir = config.bls.flakeDir;
in
{
  ns = "sudo nixos-rebuild switch --flake ${flakeDir}";
  nfu = "nix flake update ${flakeDir}";
  hms = "home-manager switch --flake ${flakeDir}";
  vim = config.bls.editor.command;
  grep = "rg";
  cat = "bat";
  ll = "ls -alh";
  ff = "fastfetch";
}
// lib.optionalAttrs config.bls.pkgs.git.enable {
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
}
// lib.optionalAttrs config.bls.pkgs.eza.enable {
  ls = "eza --icons --group-directories-first";
  ll = "eza --icons --group-directories-first -la";
}
