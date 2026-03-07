{
  imports = [
    ./bufferline.nix
    ./comment.nix
    ./gitsigns.nix
    ./indent-blankline.nix
    ./markdown-preview.nix
    ./neo-tree.nix
    ./surround.nix
    ./telescope.nix
    ./toggleterm.nix
    ./treesitter.nix
    ./trim.nix
    ./which-key.nix
  ];

  programs.nixvim.plugins = {
    web-devicons.enable = true;
  };
}
