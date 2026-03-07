{
  programs.nixvim.keymaps = [
    # Clear search highlight
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }

    # System clipboard
    {
      mode = [ "n" "v" ];
      key = "<leader>y";
      action = "\"+y";
      options.desc = "Yank to clipboard";
    }
    {
      mode = "n";
      key = "<leader>Y";
      action = "\"+Y";
      options.desc = "Yank line to clipboard";
    }
    {
      mode = [ "n" "v" ];
      key = "<leader>p";
      action = "\"+p";
      options.desc = "Paste from clipboard";
    }

    # Window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Move to left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Move to lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Move to upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Move to right window";
    }

    # Window resize
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<CR>";
      options.desc = "Increase window height";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<CR>";
      options.desc = "Decrease window height";
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<CR>";
      options.desc = "Decrease window width";
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<CR>";
      options.desc = "Increase window width";
    }

    # Splits
    {
      mode = "n";
      key = "|";
      action = "<cmd>vsplit<CR>";
      options.desc = "Vertical split";
    }
    {
      mode = "n";
      key = "-";
      action = "<cmd>split<CR>";
      options.desc = "Horizontal split";
    }

    # Buffer navigation (bufferline)
    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>BufferLineCycleNext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>bdelete<CR>";
      options.desc = "Close buffer";
    }
  ];
}
