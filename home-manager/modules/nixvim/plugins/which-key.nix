{
  programs.nixvim.plugins.which-key = {
    enable = true;

    settings = {
      delay = 300;

      win.border = "rounded";

      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "Find";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
        }
        {
          __unkeyed-1 = "<leader>b";
          desc = "Toggle file explorer";
        }
      ];
    };
  };
}
