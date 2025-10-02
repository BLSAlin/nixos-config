{pkgs, lib, ...}: let
  keyAsString = path: lib.splitString "\n" (builtins.readFile path);
in {
  programs.fish.enable = true;

  users = {
    defaultUserShell = pkgs.fish;
  };
}
