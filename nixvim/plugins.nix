{ config, ... }:

{
  plugins = {
    web-devicons.enable = true;
    friendly-snippets.enable = true;
    lazydev.enable = true;
    gitsigns.enable = true;
    which-key.enable = true;
    trouble.enable = true;
    flash.enable = true;
    noice.enable = true;
    todo-comments.enable = true;
    grug-far.enable = true;
    persistence.enable = true;
    smear-cursor.enable = true;
    render-markdown.enable = true;
    markdown-preview.enable = true;
    copilot-vim.enable = true;
    ts-autotag.enable = true;
    ts-comments.enable = true;

    mini-ai.enable = true;
    mini-pairs.enable = true;

    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
        keymap.preset = "default";
        appearance.nerd_font_variant = "mono";
        completion.documentation.auto_show = true;
        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
      };
    };

    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        bash
        css
        go
        gomod
        gosum
        gowork
        html
        javascript
        json
        lua
        markdown
        markdown_inline
        python
        query
        regex
        tsx
        typescript
        vim
        vimdoc
        vue
        yaml
      ];
    };

    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Live grep";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Buffers";
        };
        "<leader>fr" = {
          action = "oldfiles";
          options.desc = "Recent files";
        };
      };
      extensions.file-browser = {
        enable = true;
        settings = {
          theme = "ivy";
          hijack_netrw = true;
        };
      };
    };

    project-nvim = {
      enable = true;
      enableTelescope = true;
      settings = {
        detection_methods = [
          "lsp"
          "pattern"
        ];
        patterns = [
          ".git"
          "go.mod"
          "package.json"
          "pyproject.toml"
        ];
      };
    };

    snacks = {
      enable = true;
      settings = {
        bigfile.enabled = true;
        dashboard = {
          enabled = true;
          width = 80;
          preset.header = "";
          sections = [
            { __raw = "function() return require('config.dashboard_art').section() end"; }
            {
              section = "recent_files";
              title = "Recent Files";
              padding = 1;
              indent = 2;
              limit = 8;
            }
            {
              section = "projects";
              title = "Recent Projects";
              padding = 1;
              indent = 2;
              limit = 5;
            }
            { section = "startup"; }
          ];
        };
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        quickfile.enabled = true;
      };
    };

    oil = {
      enable = true;
      callSetup = false;
    };
    bufferline = {
      enable = true;
      callSetup = false;
    };
    lualine = {
      enable = true;
      callSetup = false;
    };
  };

  diagnostic.settings = {
    underline = true;
    update_in_insert = false;
    severity_sort = true;
    virtual_text = {
      spacing = 4;
      source = "if_many";
    };
  };
}
