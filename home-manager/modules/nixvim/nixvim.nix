{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    opts = {
      updatetime = 100;
      termguicolors = true; # Enables 24-bit RGB color in the |TUI|

      number = true; # Display the absolute line number of the current line
      relativenumber = true; # Relative line numbers

      mouse = "a"; # Enable mouse control
      mousemodel = "extend"; # Mouse right-click extends the current selection

      autoindent = true; # Do clever autoindenting
      confirm = true;
      clipboard = "unnamedplus";

      cursorline = true; # Highlight the screen line of the cursor
      cursorcolumn = false; # Highlight the screen column of the cursor

      modeline = true; # Tags such as 'vim:ft=sh'
      modelines = 100; # Sets the type of modelines

      list = true;
      shiftround = true;

      expandtab = true; # Expand <Tab> to spaces in Insert mode (local to buffer)
      shiftwidth = 2; # Number of spaces used for each step of (auto)indent (local to buffer)
      tabstop = 2; # Number of spaces a <Tab> in the text stands for (local to buffer)


      signcolumn = "yes"; # Whether to show the signcolumn
      smartcase = true; # Override the 'ignorecase' option if the search pattern contains upper
      smartindent = true;


      wrap = false; # Prevent text from wrapping

      ignorecase = true;
      incsearch = true;
      wildmode = "longest:full,full";


      fileencoding = "utf-8"; # File-content encoding for the current buffer

      swapfile = false; # Disable the swap file
      undofile = true;
      undolevels = 10000;

      foldlevel = 99; # Folds with a level higher than this number will be closed

#       clipboard.providers.wl-copy.enable = true;
#       extraConfigLua = ''
#         vim.opt.mouse=""
#       '';
    };
  };
}
