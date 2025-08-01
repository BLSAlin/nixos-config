{
  programs.nixvim.plugins.telescope = {
    enable = true;

    keymaps = {
      "<leader>ff" = "find_files";
      "<leader>fg" = "live_grep";
      "<leader>lb" = "buffers";
      "<leader>fh" = "help_tags";
      "<leader>fd" = "diagnostics";

      "<C-p>" = "git_files";
      "<leader>fo" = "oldfiles";
      "<C-S-f>" = "live_grep";
    };

    settings.defaults = {
      file_ignore_patterns = [
        "^.git/"
        "^.mypy_cache/"
        "^__pycache__/"
        "^output/"
        "^data/"
        "%.ipynb"
        ".idea/"
        ".vscode/"
        "target/"
      ];
    };

  };
}
