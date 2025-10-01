{ inputs, ... }:
{
  imports = [
    ./fish.nix
    ./starship/starship.nix
    ./packages.nix
  ];
}
