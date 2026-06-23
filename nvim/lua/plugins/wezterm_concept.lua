local palette = require("config.palette")

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      dimInactive = false,
      terminalColors = true,
      theme = "wave",
      overrides = function()
        return {
          Normal = { fg = palette.fg, bg = "NONE" },
          NormalNC = { fg = palette.fg_muted, bg = "NONE" },
          NormalFloat = { fg = palette.fg, bg = palette.bg_tab_bar },
          FloatBorder = { fg = palette.line, bg = palette.bg_tab_bar },
          FloatTitle = { fg = palette.mint_bright, bg = palette.bg_tab_bar, bold = true },
          Pmenu = { fg = palette.fg, bg = palette.bg_tab_bar },
          PmenuSel = { fg = palette.fg_strong, bg = palette.mint_bright, bold = true },
          PmenuSbar = { bg = palette.bg_soft },
          PmenuThumb = { bg = palette.line },
          Visual = { bg = palette.selection },
          Search = { fg = palette.fg_strong, bg = palette.peach },
          IncSearch = { fg = palette.fg_strong, bg = palette.mint_bright },
          CurSearch = { fg = palette.fg_strong, bg = palette.mint_bright },
          CursorLine = { bg = palette.bg_deep },
          CursorLineNr = { fg = palette.mint_bright, bold = true },
          LineNr = { fg = palette.sage },
          SignColumn = { bg = "NONE" },
          EndOfBuffer = { fg = palette.bg_soft },
          WinSeparator = { fg = palette.line },
          VertSplit = { fg = palette.line },
          StatusLine = { fg = palette.fg, bg = palette.bg_tab_bar },
          StatusLineNC = { fg = palette.fg_muted, bg = palette.bg_tab_bar },
          TabLineFill = { bg = "NONE" },
          TelescopeNormal = { fg = palette.fg, bg = palette.bg_tab_bar },
          TelescopeBorder = { fg = palette.line, bg = palette.bg_tab_bar },
          TelescopeTitle = { fg = palette.fg_strong, bg = palette.mint_bright, bold = true },
          TelescopePromptNormal = { fg = palette.fg, bg = palette.bg_soft },
          TelescopePromptBorder = { fg = palette.line, bg = palette.bg_soft },
          TelescopePromptTitle = { fg = palette.fg_strong, bg = palette.peach, bold = true },
          TelescopePreviewTitle = { fg = palette.fg_strong, bg = palette.mint_bright, bold = true },
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
          DiagnosticVirtualTextWarn = { fg = "#e6d79c", bg = palette.bg_tab_bar },
          DiagnosticVirtualTextInfo = { fg = "#8fb6d9", bg = palette.bg_tab_bar },
          DiagnosticVirtualTextHint = { fg = palette.mint, bg = palette.bg_tab_bar },
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
      opts.options.separator_style = "thin"
      opts.options.indicator = { style = "none" }
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false
      opts.options.show_buffer_icons = false
      opts.options.color_icons = false
      opts.options.offsets = opts.options.offsets or {}
      opts.highlights = vim.tbl_extend("force", opts.highlights or {}, {
        fill = { bg = palette.bg_tab_bar },
        background = { fg = palette.fg_muted, bg = palette.bg_tab },
        buffer_visible = { fg = palette.fg_muted, bg = palette.bg_tab },
        buffer_selected = { fg = palette.fg_strong, bg = palette.bg_tab_active, bold = true, italic = false },
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
          a = { fg = palette.fg_strong, bg = palette.mint_bright, gui = "bold" },
          b = { fg = palette.fg, bg = palette.bg_tab },
          c = { fg = palette.fg_muted, bg = palette.bg_tab_bar },
        },
        insert = {
          a = { fg = palette.fg_strong, bg = palette.peach, gui = "bold" },
        },
        visual = {
          a = { fg = palette.fg_strong, bg = palette.bg_tab_active, gui = "bold" },
        },
        replace = {
          a = { fg = palette.fg_strong, bg = "#f2a8b5", gui = "bold" },
        },
        command = {
          a = { fg = palette.fg_strong, bg = "#e6d79c", gui = "bold" },
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
        section_separators = { left = "", right = "" },
        globalstatus = true,
      })

      opts.sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" }, padding = { left = 1, right = 1 } } },
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
        lualine_z = { { "location", separator = { left = "", right = "" } } },
      }
    end,
  },
}
