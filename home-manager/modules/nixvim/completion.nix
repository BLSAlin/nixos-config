{
  programs.nixvim.plugins.blink-cmp = {
    enable = true;

    settings = {
      keymap.preset = "default";

      appearance.nerd_font_variant = "mono";

      sources = {
        default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
      };

      completion = {
        menu.border = "rounded";
        documentation = {
          auto_show = true;
          window.border = "rounded";
        };
      };

      signature.enabled = true;
    };
  };
}
