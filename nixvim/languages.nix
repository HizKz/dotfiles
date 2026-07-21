{ pkgs, ... }:

{
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      keymaps = {
        silent = true;
        diagnostic = {
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };
        lspBuf = {
          gd = "definition";
          gr = "references";
          gI = "implementation";
          gy = "type_definition";
          K = "hover";
          "<leader>ca" = "code_action";
          "<leader>cr" = "rename";
        };
      };
      servers = {
        gopls = {
          enable = true;
          package = null;
          settings.gopls = {
            gofumpt = true;
            staticcheck = true;
            usePlaceholders = true;
            completeUnimported = true;
            analyses = {
              nilness = true;
              shadow = true;
              unusedparams = true;
              unusedwrite = true;
              useany = true;
            };
            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = true;
              compositeLiteralTypes = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };
          };
        };
        pyright = {
          enable = true;
          package = null;
          settings.python.analysis = {
            extraPaths = [ "./" ];
            typeCheckingMode = "basic";
          };
        };
        ts_ls = {
          enable = true;
          package = null;
        };
        volar = {
          enable = true;
          package = null;
          tslsIntegration = false;
        };
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          go = [
            "goimports"
            "gofumpt"
          ];
          python = [
            "ruff_organize_imports"
            "ruff_format"
          ];
          javascript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescript = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          vue = [ "prettier" ];
        };
        format_on_save = {
          timeout_ms = 3000;
          lsp_format = "fallback";
        };
        notify_on_error = true;
        notify_no_formatters = false;
      };
    };

    lint = {
      enable = true;
      lintersByFt = {
        go = [ "golangcilint" ];
        python = [ "ruff" ];
        markdown = [ ];
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    go-nvim
    guihua-lua
  ];

  extraConfigLuaPost = ''
    require("go").setup({
      lsp_cfg = false,
      lsp_gofumpt = true,
      trouble = true,
      test_runner = "go",
    })
  '';
}
