{ inputs, ... }:
{
  imports = [
    ./packages.nix
    ./tmux.nix
    ./git.nix
  ];
}
