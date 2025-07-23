{
  imports = [
    ./barbar.nix
    ./comment.nix
    ./gitsigns.nix
    ./lualine.nix
    ./markdown-preview.nix
    ./neo-tree.nix
    ./startify.nix
    ./treesitter.nix
    ./trim.nix
  ];


  programs.nixvim = {
    plugins = {
      lz-n.enable = true;
      web-devicons.enable = true;
      nvim-autopairs.enable = true;

      oil = {
        enable = true;
        lazyLoad.settings.cmd = "Oil";
      };
    };
  };
}
