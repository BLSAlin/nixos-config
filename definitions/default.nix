{ lib, ... }:
{
  imports = [
    ./shell.nix
  ];

  options.bls.flakeDir = lib.mkOption {
    type = lib.types.str;
    default = "~/Projects/nix/nixos-config";
    description = "Default flake directory used in generated shell commands.";
  };
}
