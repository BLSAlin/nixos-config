{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bls.pkgs.tmux;
in
{
  imports = [
    ./home-manager.nix
  ];

  options.bls.pkgs.tmux.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable preferred tmux configuration.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.tmux
    ];
  };
}
