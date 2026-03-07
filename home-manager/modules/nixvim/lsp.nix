{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;

      keymaps = {
        lspBuf = {
          "gd" = {
            action = "definition";
            desc = "Go to definition";
          };
          "gD" = {
            action = "declaration";
            desc = "Go to declaration";
          };
          "gr" = {
            action = "references";
            desc = "Go to references";
          };
          "gi" = {
            action = "implementation";
            desc = "Go to implementation";
          };
          "gt" = {
            action = "type_definition";
            desc = "Go to type definition";
          };
          "K" = {
            action = "hover";
            desc = "Hover documentation";
          };
          "<leader>rn" = {
            action = "rename";
            desc = "Rename symbol";
          };
          "<leader>ca" = {
            action = "code_action";
            desc = "Code action";
          };
          "<leader>f" = {
            action = "format";
            desc = "Format buffer";
          };
        };
      };

      servers = {
        nil_ls = {
          enable = true;
          settings.formatting.command = [ "nixfmt" ];
        };

        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          settings = {
            check.command = "clippy";
            inlayHints = {
              closingBraceHints.enable = true;
              parameterHints.enable = true;
              typeHints.enable = true;
            };
          };
        };

        gopls = {
          enable = true;
          settings.gofumpt = true;
        };

        basedpyright = {
          enable = true;
          settings.basedpyright.typeCheckingMode = "standard";
        };

        jdtls.enable = true;

        csharp_ls.enable = true;
      };
    };
  };
}
