{ lib, ... }:
{
  options.bls.editor.default = lib.mkOption {
    type = lib.types.enum [ "helix" ];
    default = "helix";
    description = "Default editor preference.";
  };
}
