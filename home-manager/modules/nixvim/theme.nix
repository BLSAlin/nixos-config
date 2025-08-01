{
  programs.nixvim.colorschemes.catppuccin = {
    enable = true;

    settings = {
      color_overrides = {
        mocha = {
          mauve = "#ff59ac";
          maroon = "#eea481";
          yellow = "#fedf9b";
          text = "#f9f9f9";
          base = "#000000";
          mantle = "#000000";
          crust = "#000000";
        };
      };
    };
  };
}
