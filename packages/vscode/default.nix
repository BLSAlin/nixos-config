{
  config,
  lib,
  ...
}:
let
  cfg = config.bls.pkgs.vscode;
in
{
  imports = [
    ./home-manager.nix
  ];

  options.bls.pkgs.vscode.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable preferred VS Code configuration.";
  };

  config = lib.mkIf cfg.enable { };
}
