{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim

    ./nixvim.nix
    ./autocommands.nix
    ./completion.nix
    ./plugins/bundle.nix
  ];
}
