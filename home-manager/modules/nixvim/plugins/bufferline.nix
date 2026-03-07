{
  programs.nixvim.plugins.bufferline = {
    enable = true;

    settings.options = {
      diagnostics = "nvim_lsp";
      separator_style = "thin";
      show_buffer_close_icons = false;
      show_close_icon = false;
    };
  };
}
