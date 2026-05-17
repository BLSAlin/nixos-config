{ lib, ... }:
let
  entries = builtins.readDir ./.;
  packageDirs =
    lib.filterAttrs
      (name: type: type == "directory" && builtins.pathExists (./. + "/${name}/default.nix"))
      entries;
in
{
  imports = map (name: ./. + "/${name}/default.nix") (lib.attrNames packageDirs);
}
