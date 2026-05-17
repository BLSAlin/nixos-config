{ lib, ... }:
{
  options.bls.shell.defaultShell = lib.mkOption {
    type = lib.types.enum [ "fish" ];
    default = "fish";
    description = "Default system-wide shell.";
  };
}
