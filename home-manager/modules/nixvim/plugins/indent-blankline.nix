{
  programs.nixvim.plugins.indent-blankline = {
    enable = true;

    settings = {
      indent.char = "│";
      scope.enabled = false;
      exclude.filetypes = [
        "help"
        "dashboard"
        "neo-tree"
        "Trouble"
        "lazy"
        "toggleterm"
      ];
    };
  };
}
