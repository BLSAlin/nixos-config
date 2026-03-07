{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      nixvimInjections = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      folding.enable = true;
    };

    treesitter-textobjects = {
      enable = true;

      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = {
              query = "@function.outer";
              desc = "Select outer function";
            };
            "if" = {
              query = "@function.inner";
              desc = "Select inner function";
            };
            "ac" = {
              query = "@class.outer";
              desc = "Select outer class";
            };
            "ic" = {
              query = "@class.inner";
              desc = "Select inner class";
            };
            "aa" = {
              query = "@parameter.outer";
              desc = "Select outer parameter";
            };
            "ia" = {
              query = "@parameter.inner";
              desc = "Select inner parameter";
            };
          };
        };

        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]m" = {
              query = "@function.outer";
              desc = "Next function start";
            };
            "]]" = {
              query = "@class.outer";
              desc = "Next class start";
            };
          };
          goto_previous_start = {
            "[m" = {
              query = "@function.outer";
              desc = "Previous function start";
            };
            "[[" = {
              query = "@class.outer";
              desc = "Previous class start";
            };
          };
        };

        swap = {
          enable = true;
          swap_next = {
            "<leader>a" = {
              query = "@parameter.inner";
              desc = "Swap with next parameter";
            };
          };
          swap_previous = {
            "<leader>A" = {
              query = "@parameter.inner";
              desc = "Swap with previous parameter";
            };
          };
        };
      };
    };

    hmts.enable = true;
  };
}
