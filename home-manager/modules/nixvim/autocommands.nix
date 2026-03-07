{
  programs.nixvim = {
    autoCmd = [
      # Highlight on yank
      {
        event = "TextYankPost";
        callback.__raw = ''
          function()
            vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
          end
        '';
      }

      # Enable spellcheck for some filetypes
      {
        event = "FileType";
        pattern = [
          "tex"
          "latex"
          "markdown"
        ];
        command = "setlocal spell spelllang=en";
      }
    ];

    # Per-language indentation via ftplugin
    files = {
      "after/ftplugin/python.lua".localOpts = {
        shiftwidth = 4;
        tabstop = 4;
        softtabstop = 4;
      };
      "after/ftplugin/rust.lua".localOpts = {
        shiftwidth = 4;
        tabstop = 4;
        softtabstop = 4;
      };
      "after/ftplugin/go.lua".localOpts = {
        shiftwidth = 4;
        tabstop = 4;
        softtabstop = 4;
        expandtab = false;
      };
    };
  };
}
