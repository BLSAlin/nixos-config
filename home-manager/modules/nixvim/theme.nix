{
  programs.nixvim.colorschemes.catppuccin = {
    enable = true;

    settings = {
      flavor = "mocha";

      color_overrides = {
        mocha = {
          base = "#000000";
          mantle = "#000000";
          crust = "#000000";
          surface0 = "#1a1a1a";
          surface1 = "#2a2a2a";
          surface2 = "#3a3a3a";
          overlay0 = "#4a4a4a";
          overlay1 = "#5a5a5a";
          overlay2 = "#6a6a6a";
          text = "#f9f9f9";
          subtext0 = "#cccccc";
          subtext1 = "#dddddd";
          mauve = "#ff59ac";
          peach = "#ffaa66";
          maroon = "#eea481";
          yellow = "#fedf9b";
        };
      };

      integrations = {
        gitsigns = true;
        treesitter = true;
        indent_blankline.enabled = true;
        which_key = true;
        telescope.enabled = true;
        native_lsp.enabled = true;
      };
    };
  };
}
