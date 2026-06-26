local palette = require("config.palette")

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      theme = "wave",
      overrides = function()
        return {
          Normal = { fg = palette.fg, bg = palette.bg },
          NormalNC = { fg = palette.fg_muted, bg = palette.bg },
          NormalFloat = { fg = palette.fg, bg = palette.bg_tab_bar },
          FloatBorder = { fg = palette.line, bg = palette.bg_tab_bar },
          FloatTitle = { fg = palette.mint_bright, bg = palette.bg_tab_bar, bold = true },
          Pmenu = { fg = palette.fg, bg = palette.bg_tab_bar },
          PmenuSel = { fg = palette.fg_strong, bg = palette.bg_tab_active, bold = true },
          PmenuSbar = { bg = palette.bg_soft },
          PmenuThumb = { bg = palette.line },
          Visual = { bg = palette.selection },
          Search = { fg = palette.fg_strong, bg = palette.peach },
          IncSearch = { fg = palette.fg_strong, bg = palette.mint_bright },
          CurSearch = { fg = palette.fg_strong, bg = palette.mint_bright },
          CursorLine = { bg = palette.bg_deep },
          CursorLineNr = { fg = palette.mint_bright, bold = true },
          LineNr = { fg = palette.sage },
          Comment = { fg = palette.sage, italic = true },
          Keyword = { fg = palette.rose, bold = true },
          Conditional = { fg = palette.rose, bold = true },
          Repeat = { fg = palette.rose, bold = true },
          Function = { fg = palette.mint_bright },
          Identifier = { fg = palette.fg_tab },
          String = { fg = palette.aqua },
          Character = { fg = palette.aqua },
          Type = { fg = palette.mint },
          Constant = { fg = palette.peach },
          Number = { fg = palette.peach },
          Boolean = { fg = palette.peach, bold = true },
          Special = { fg = palette.lemon },
          ["@keyword"] = { fg = palette.rose, bold = true },
          ["@function"] = { fg = palette.mint_bright },
          ["@function.method"] = { fg = palette.mint_bright },
          ["@string"] = { fg = palette.aqua },
          ["@type"] = { fg = palette.mint },
          ["@variable"] = { fg = palette.fg_tab },
          ["@property"] = { fg = palette.fg },
          SignColumn = { bg = palette.bg },
          EndOfBuffer = { fg = palette.bg_soft },
          WinSeparator = { fg = palette.line },
          VertSplit = { fg = palette.line },
          StatusLine = { fg = palette.fg, bg = palette.bg_tab_bar },
          StatusLineNC = { fg = palette.fg_muted, bg = palette.bg_tab_bar },
          TabLineFill = { bg = palette.bg_tab_bar },
          TelescopeNormal = { fg = palette.fg, bg = palette.bg_tab_bar },
          TelescopeBorder = { fg = palette.line, bg = palette.bg_tab_bar },
          TelescopeTitle = { fg = palette.fg_strong, bg = palette.bg_tab_active, bold = true },
          TelescopePromptNormal = { fg = palette.fg, bg = palette.bg_soft },
          TelescopePromptBorder = { fg = palette.line, bg = palette.bg_soft },
          TelescopePromptTitle = { fg = palette.fg_strong, bg = palette.peach, bold = true },
          TelescopePreviewTitle = { fg = palette.fg_strong, bg = palette.bg_tab_active, bold = true },
          TelescopeResultsTitle = { fg = palette.fg_strong, bg = palette.bg_tab_active, bold = true },
          SnacksDashboardHeader = { fg = palette.mint_bright },
          SnacksDashboardDesc = { fg = palette.fg_muted },
          SnacksDashboardDir = { fg = palette.sage },
          SnacksDashboardFile = { fg = palette.fg },
          SnacksDashboardSpecial = { fg = palette.peach },
          SnacksDashboardTitle = { fg = palette.mint, bold = true },
          LazyNormal = { fg = palette.fg, bg = palette.bg_tab_bar },
          LazyBorder = { fg = palette.line, bg = palette.bg_tab_bar },
          MasonNormal = { fg = palette.fg, bg = palette.bg_tab_bar },
          DiagnosticVirtualTextError = { fg = palette.peach, bg = palette.bg_tab_bar },
          DiagnosticVirtualTextWarn = { fg = palette.lemon, bg = palette.bg_tab_bar },
          DiagnosticVirtualTextInfo = { fg = palette.aqua, bg = palette.bg_tab_bar },
          DiagnosticVirtualTextHint = { fg = palette.mint, bg = palette.bg_tab_bar },
          WinBar = { fg = palette.fg_muted, bg = palette.bg_soft },
          WinBarNC = { fg = palette.sage, bg = palette.bg_soft },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.always_show_bufferline = true
      opts.options.numbers = "ordinal"
      opts.options.separator_style = "thin"
      opts.options.indicator = { style = "none" }
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false
      opts.options.show_buffer_icons = true
      opts.options.color_icons = true
      opts.options.diagnostics = "nvim_lsp"
      opts.options.offsets = {
        {
          filetype = "oil",
          text = "Explorer",
          highlight = "WinBar",
          text_align = "left",
          separator = true,
        },
      }
      opts.highlights = vim.tbl_extend("force", opts.highlights or {}, {
        fill = { bg = palette.bg_tab_bar },
        background = { fg = palette.fg_muted, bg = palette.bg_tab },
        buffer_visible = { fg = palette.fg_muted, bg = palette.bg_tab },
        buffer_selected = { fg = palette.fg_strong, bg = palette.bg_tab_active, bold = true, italic = false },
        numbers = { fg = palette.fg_muted, bg = palette.bg_tab, bold = true },
        numbers_visible = { fg = palette.fg_muted, bg = palette.bg_tab, bold = true },
        numbers_selected = { fg = palette.fg_strong, bg = palette.bg_tab_active, bold = true },
        duplicate = { fg = palette.fg_muted, bg = palette.bg_tab, italic = false },
        duplicate_selected = { fg = palette.fg_strong, bg = palette.bg_tab_active, italic = false },
        separator = { fg = palette.bg_tab_bar, bg = palette.bg_tab_bar },
        separator_selected = { fg = palette.bg_tab_bar, bg = palette.bg_tab_bar },
        separator_visible = { fg = palette.bg_tab_bar, bg = palette.bg_tab_bar },
        modified = { fg = palette.peach, bg = palette.bg_tab },
        modified_selected = { fg = palette.peach, bg = palette.bg_tab_active },
        hint = { fg = palette.sage, bg = palette.bg_tab },
        hint_selected = { fg = palette.sage, bg = palette.bg_tab_active },
        diagnostic = { fg = palette.fg_muted, bg = palette.bg_tab },
        diagnostic_selected = { fg = palette.fg_strong, bg = palette.bg_tab_active },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local theme = {
        normal = {
          a = { fg = palette.fg_strong, bg = palette.bg_tab_active, gui = "bold" },
          b = { fg = palette.fg, bg = palette.bg_tab_bar },
          c = { fg = palette.fg_muted, bg = palette.bg_tab_bar },
        },
        insert = {
          a = { fg = palette.fg_strong, bg = palette.selection, gui = "bold" },
        },
        visual = {
          a = { fg = palette.fg_strong, bg = palette.rose, gui = "bold" },
        },
        replace = {
          a = { fg = palette.fg_strong, bg = palette.rose, gui = "bold" },
        },
        command = {
          a = { fg = palette.fg_strong, bg = palette.lemon, gui = "bold" },
        },
        inactive = {
          a = { fg = palette.fg_muted, bg = palette.bg_tab_bar },
          b = { fg = palette.fg_muted, bg = palette.bg_tab_bar },
          c = { fg = palette.sage, bg = palette.bg_tab_bar },
        },
      }

      opts.options = vim.tbl_extend("force", opts.options or {}, {
        theme = theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      })

      opts.sections = {
        lualine_a = { { "mode", padding = { left = 1, right = 1 } } },
        lualine_b = { "branch", "diff" },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = { modified = " ●", readonly = " 󰌾", unnamed = "[No Name]" },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
          },
          "encoding",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      }
    end,
  },
}
