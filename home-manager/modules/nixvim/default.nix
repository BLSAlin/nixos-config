{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim

    ./nixvim.nix
    ./autocommands.nix
    ./completion.nix
    ./theme.nix
    ./plugins/default.nix
  ];
}
