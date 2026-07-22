{ pkgs, ... }:

let
  mapKey = mode: key: action: desc: {
    inherit mode key action;
    options = {
      inherit desc;
      silent = true;
      remap = false;
    };
  };
  diagnosticJump = count: severity: {
    __raw = ''
      function()
        vim.diagnostic.jump({
          count = ${toString count} * vim.v.count1,
          severity = ${severity},
          float = true,
        })
      end
    '';
  };
in
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

  keymaps = [
    (mapKey "n" "gD" { __raw = "vim.lsp.buf.declaration"; } "Go to Declaration")
    (mapKey "n" "gK" { __raw = "vim.lsp.buf.signature_help"; } "Signature Help")
    (mapKey "i" "<C-k>" { __raw = "vim.lsp.buf.signature_help"; } "Signature Help")
    (mapKey "x" "<leader>ca" { __raw = "vim.lsp.buf.code_action"; } "Code Action")
    (mapKey [ "n" "x" ] "<leader>cf" { __raw = "function() require('conform').format({ async = true, lsp_format = 'fallback' }) end"; } "Format")
    (mapKey "n" "<leader>cl" "<cmd>LspInfo<cr>" "LSP Info")
    (mapKey [ "n" "x" ] "<leader>cc" { __raw = "vim.lsp.codelens.run"; } "Run Codelens")
    (mapKey "n" "<leader>cC" { __raw = "vim.lsp.codelens.refresh"; } "Refresh Codelens")
    (mapKey "n" "<leader>cd" { __raw = "vim.diagnostic.open_float"; } "Line Diagnostics")
    (mapKey "n" "]d" (diagnosticJump 1 "nil") "Next Diagnostic")
    (mapKey "n" "[d" (diagnosticJump (-1) "nil") "Previous Diagnostic")
    (mapKey "n" "]e" (diagnosticJump 1 "vim.diagnostic.severity.ERROR") "Next Error")
    (mapKey "n" "[e" (diagnosticJump (-1) "vim.diagnostic.severity.ERROR") "Previous Error")
    (mapKey "n" "]w" (diagnosticJump 1 "vim.diagnostic.severity.WARN") "Next Warning")
    (mapKey "n" "[w" (diagnosticJump (-1) "vim.diagnostic.severity.WARN") "Previous Warning")
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
