{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim

    ./options.nix
    ./keymaps.nix
    ./autocommands.nix
    ./completion.nix
    ./lsp.nix
    ./theme.nix
    ./statusline.nix
    ./plugins/default.nix
  ];
}
