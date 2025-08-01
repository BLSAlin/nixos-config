{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>b";
        action = ":Neotree action=focus reveal toggle<CR>";
        options.silent = true;
      }
    ];

    plugins.neo-tree = {
      enable = true;

      closeIfLastWindow = true;
      window = {
        width = 30;
        autoExpandWidth = true;
      };
    };

  };

}
