{ config, ... }:

let
  projectRoot = "require('project').current_project() or vim.uv.cwd()";
  mapKey = mode: key: action: desc: {
    inherit mode key action;
    options = {
      inherit desc;
      silent = true;
      remap = false;
    };
  };
  normal = mapKey "n";
in
{
  plugins = {
    web-devicons.enable = true;
    friendly-snippets.enable = true;
    lazydev.enable = true;
    gitsigns.enable = true;
    which-key = {
      enable = true;
      settings.spec = [
        {
          __unkeyed-1 = "<leader><tab>";
          group = "tabs";
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "buffer";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "code";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "file/find";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "git";
        }
        {
          __unkeyed-1 = "<leader>gh";
          group = "hunks";
        }
        {
          __unkeyed-1 = "<leader>q";
          group = "quit/session";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "search";
        }
        {
          __unkeyed-1 = "<leader>sn";
          group = "noice";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "ui";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "windows";
        }
        {
          __unkeyed-1 = "<leader>x";
          group = "diagnostics/quickfix";
        }
        {
          __unkeyed-1 = "[";
          group = "previous";
        }
        {
          __unkeyed-1 = "]";
          group = "next";
        }
      ];
    };
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

  keymaps = [
    (normal "<leader>?" { __raw = "function() require('which-key').show({ global = false }) end"; } "Buffer Keymaps")
    (normal "<leader>j" { __raw = "function() require('flash').jump() end"; } "Flash Jump")
    (normal "<leader>J" { __raw = "function() require('flash').treesitter() end"; } "Flash Treesitter")

    (normal "<leader>," "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" "Switch Buffer")
    (normal "<leader>/" { __raw = "function() require('telescope.builtin').live_grep({ cwd = ${projectRoot} }) end"; } "Grep Project")
    (normal "<leader>:" "<cmd>Telescope command_history<cr>" "Command History")
    (normal "<leader><space>" { __raw = "function() require('telescope.builtin').find_files({ cwd = ${projectRoot} }) end"; } "Find Files in Project")
    (normal "<leader>fb" "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>" "Buffers")
    (normal "<leader>fB" "<cmd>Telescope buffers<cr>" "All Buffers")
    (normal "<leader>ff" { __raw = "function() require('telescope.builtin').find_files({ cwd = ${projectRoot} }) end"; } "Find Files in Project")
    (normal "<leader>fF" { __raw = "function() require('telescope.builtin').find_files({ cwd = vim.uv.cwd() }) end"; } "Find Files in cwd")
    (normal "<leader>fg" { __raw = "function() require('telescope.builtin').git_files({ cwd = ${projectRoot} }) end"; } "Find Git Files")
    (normal "<leader>fp" "<cmd>Telescope projects<cr>" "Projects")
    (normal "<leader>fr" "<cmd>Telescope oldfiles<cr>" "Recent Files")
    (normal "<leader>fR" { __raw = "function() require('telescope.builtin').oldfiles({ cwd = vim.uv.cwd(), only_cwd = true }) end"; } "Recent Files in cwd")

    (normal "<leader>gc" "<cmd>Telescope git_commits<cr>" "Git Commits")
    (normal "<leader>gl" "<cmd>Telescope git_commits<cr>" "Git Log")
    (normal "<leader>gs" "<cmd>Telescope git_status<cr>" "Git Status")
    (normal "<leader>gS" "<cmd>Telescope git_stash<cr>" "Git Stash")

    (normal "<leader>s/" "<cmd>Telescope search_history<cr>" "Search History")
    (normal "<leader>sa" "<cmd>Telescope autocommands<cr>" "Auto Commands")
    (normal "<leader>sb" "<cmd>Telescope current_buffer_fuzzy_find<cr>" "Buffer Lines")
    (normal "<leader>sc" "<cmd>Telescope command_history<cr>" "Command History")
    (normal "<leader>sC" "<cmd>Telescope commands<cr>" "Commands")
    (normal "<leader>sd" "<cmd>Telescope diagnostics<cr>" "Diagnostics")
    (normal "<leader>sD" "<cmd>Telescope diagnostics bufnr=0<cr>" "Buffer Diagnostics")
    (normal "<leader>sg" { __raw = "function() require('telescope.builtin').live_grep({ cwd = ${projectRoot} }) end"; } "Grep Project")
    (normal "<leader>sG" { __raw = "function() require('telescope.builtin').live_grep({ cwd = vim.uv.cwd() }) end"; } "Grep cwd")
    (normal "<leader>sh" "<cmd>Telescope help_tags<cr>" "Help Pages")
    (normal "<leader>sH" "<cmd>Telescope highlights<cr>" "Highlight Groups")
    (normal "<leader>sj" "<cmd>Telescope jumplist<cr>" "Jumplist")
    (normal "<leader>sk" "<cmd>Telescope keymaps<cr>" "Keymaps")
    (normal "<leader>sl" "<cmd>Telescope loclist<cr>" "Location List")
    (normal "<leader>sM" "<cmd>Telescope man_pages<cr>" "Man Pages")
    (normal "<leader>sm" "<cmd>Telescope marks<cr>" "Marks")
    (normal "<leader>so" "<cmd>Telescope vim_options<cr>" "Options")
    (normal "<leader>sq" "<cmd>Telescope quickfix<cr>" "Quickfix List")
    (normal "<leader>sR" "<cmd>Telescope resume<cr>" "Resume Search")
    (normal "<leader>ss" "<cmd>Telescope lsp_document_symbols<cr>" "Document Symbols")
    (normal "<leader>sS" "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" "Workspace Symbols")
    (normal "<leader>sw" { __raw = "function() require('telescope.builtin').grep_string({ cwd = ${projectRoot}, word_match = '-w' }) end"; } "Search Word in Project")
    (normal "<leader>sW" { __raw = "function() require('telescope.builtin').grep_string({ cwd = vim.uv.cwd(), word_match = '-w' }) end"; } "Search Word in cwd")
    (mapKey "x" "<leader>sw" { __raw = "function() require('telescope.builtin').grep_string({ cwd = ${projectRoot} }) end"; } "Search Selection in Project")
    (mapKey "x" "<leader>sW" { __raw = "function() require('telescope.builtin').grep_string({ cwd = vim.uv.cwd() }) end"; } "Search Selection in cwd")

    (mapKey [ "n" "x" ] "<leader>sr" "<cmd>GrugFar<cr>" "Search and Replace")
    (normal "]h" { __raw = "function() if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else require('gitsigns').nav_hunk('next') end end"; } "Next Hunk")
    (normal "[h" { __raw = "function() if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else require('gitsigns').nav_hunk('prev') end end"; } "Previous Hunk")
    (normal "]H" { __raw = "function() require('gitsigns').nav_hunk('last') end"; } "Last Hunk")
    (normal "[H" { __raw = "function() require('gitsigns').nav_hunk('first') end"; } "First Hunk")
    (mapKey [ "n" "x" ] "<leader>ghs" "<cmd>Gitsigns stage_hunk<cr>" "Stage Hunk")
    (mapKey [ "n" "x" ] "<leader>ghr" "<cmd>Gitsigns reset_hunk<cr>" "Reset Hunk")
    (normal "<leader>ghS" "<cmd>Gitsigns stage_buffer<cr>" "Stage Buffer")
    (normal "<leader>ghu" "<cmd>Gitsigns undo_stage_hunk<cr>" "Undo Stage Hunk")
    (normal "<leader>ghR" "<cmd>Gitsigns reset_buffer<cr>" "Reset Buffer")
    (normal "<leader>ghp" "<cmd>Gitsigns preview_hunk_inline<cr>" "Preview Hunk")
    (normal "<leader>ghb" "<cmd>Gitsigns blame_line full=true<cr>" "Blame Line")
    (normal "<leader>ghB" "<cmd>Gitsigns blame<cr>" "Blame Buffer")
    (normal "<leader>ghd" "<cmd>Gitsigns diffthis<cr>" "Diff This")
    (normal "<leader>ghD" "<cmd>Gitsigns diffthis ~<cr>" "Diff This Against HEAD")

    (normal "<leader>xx" "<cmd>Trouble diagnostics toggle<cr>" "Diagnostics")
    (normal "<leader>xX" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" "Buffer Diagnostics")
    (normal "<leader>cs" "<cmd>Trouble symbols toggle<cr>" "Symbols")
    (normal "<leader>cS" "<cmd>Trouble lsp toggle<cr>" "LSP Definitions and References")
    (normal "<leader>xL" "<cmd>Trouble loclist toggle<cr>" "Location List")
    (normal "<leader>xQ" "<cmd>Trouble qflist toggle<cr>" "Quickfix List")
    (normal "]t" { __raw = "function() require('todo-comments').jump_next() end"; } "Next Todo")
    (normal "[t" { __raw = "function() require('todo-comments').jump_prev() end"; } "Previous Todo")
    (normal "<leader>xt" "<cmd>Trouble todo toggle<cr>" "Todo List")
    (normal "<leader>xT" "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>" "Todo/Fix/Fixme List")
    (normal "<leader>st" "<cmd>TodoTelescope<cr>" "Todo Search")
    (normal "<leader>sT" "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>" "Todo/Fix/Fixme Search")

    (normal "<leader>snl" { __raw = "function() require('noice').cmd('last') end"; } "Noice Last Message")
    (normal "<leader>snh" { __raw = "function() require('noice').cmd('history') end"; } "Noice History")
    (normal "<leader>sna" { __raw = "function() require('noice').cmd('all') end"; } "Noice All Messages")
    (normal "<leader>snd" { __raw = "function() require('noice').cmd('dismiss') end"; } "Dismiss Noice Messages")
    (normal "<leader>snt" { __raw = "function() require('noice').cmd('pick') end"; } "Noice Message Picker")
    (normal "<leader>n" { __raw = "function() Snacks.notifier.show_history() end"; } "Notification History")
    (normal "<leader>un" { __raw = "function() Snacks.notifier.hide() end"; } "Dismiss Notifications")

    (normal "<leader>qs" { __raw = "function() require('persistence').load() end"; } "Restore Session")
    (normal "<leader>qS" { __raw = "function() require('persistence').select() end"; } "Select Session")
    (normal "<leader>ql" { __raw = "function() require('persistence').load({ last = true }) end"; } "Restore Last Session")
    (normal "<leader>qd" { __raw = "function() require('persistence').stop() end"; } "Do Not Save Session")
    (normal "<leader>cp" "<cmd>MarkdownPreviewToggle<cr>" "Toggle Markdown Preview")
  ];

  extraFiles."lua/config/markdown.lua".source = ./lua/markdown.lua;
  extraConfigLuaPost = ''
    require("config.markdown")
  '';
}
