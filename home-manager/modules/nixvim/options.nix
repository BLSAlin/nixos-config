{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    opts = {
      updatetime = 100;
      termguicolors = true;

      number = true;
      relativenumber = true;

      mouse = "a";
      mousemodel = "extend";

      scrolloff = 8;
      cursorline = true;
      signcolumn = "yes";

      splitright = true;
      splitbelow = true;

      autoindent = true;
      smartindent = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      shiftround = true;

      ignorecase = true;
      smartcase = true;
      incsearch = true;

      undofile = true;
      undolevels = 10000;

      foldlevel = 99;

      list = true;
      confirm = true;
      modeline = true;
      modelines = 100;
      wildmode = "longest:full,full";
      fileencoding = "utf-8";
    };
  };
}
