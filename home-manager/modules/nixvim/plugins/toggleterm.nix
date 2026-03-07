{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        direction = "horizontal";
        size = 15;
        open_mapping.__raw = "[[<C-\\>]]";
      };
    };

    keymaps = [
      {
        mode = "t";
        key = "<C-\\>";
        action = "<cmd>ToggleTerm<CR>";
        options.desc = "Toggle terminal";
      }
    ];
  };
}
