{
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;

      settings = {
        close_if_last_window = true;

        window = {
          position = "left";
          width = 30;
        };

        filesystem = {
          follow_current_file.enabled = true;
          hijack_netrw_behavior = "open_current";
          filtered_items.visible = true;
        };

        default_component_configs = {
          indent.with_expanders = true;
          git_status.symbols = {
            added = "+";
            modified = "~";
            deleted = "x";
            renamed = "r";
            untracked = "?";
            ignored = "i";
            staged = "s";
            conflict = "!";
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>b";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle file explorer";
      }
    ];
  };
}
