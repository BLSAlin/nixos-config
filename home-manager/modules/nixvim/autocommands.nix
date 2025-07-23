{
  programs.nixvim.autoCmd = [

    # Vertically center document when entering insert mode
    {
      event = "InsertEnter";
      command = "norm zz";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex" # inria
        "latex" # inria
        "markdown"
      ];
      command = "setlocal spell spelllang=en";
    }

  ];
}
