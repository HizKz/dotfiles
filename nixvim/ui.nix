let
  palette = {
    bg = "#12211f";
    bg_deep = "#19312d";
    bg_soft = "#223f39";
    bg_tab_bar = "#172926";
    bg_tab = "#25453f";
    bg_tab_active = "#c8f3e7";
    fg = "#e8f7f1";
    fg_strong = "#1f3430";
    fg_muted = "#9fc8bc";
    fg_tab = "#dff8f0";
    mint = "#95ebd4";
    mint_bright = "#c9f8ec";
    sage = "#79a89e";
    line = "#4f7d74";
    selection = "#294b45";
    peach = "#f6cdbf";
    rose = "#f4b7cc";
    aqua = "#8ee6df";
    lemon = "#f4ecb0";
  };
in
{
  colorschemes.kanagawa = {
    enable = true;
    settings = {
      transparent = false;
      dimInactive = false;
      terminalColors = true;
      theme = "wave";
      overrides = ''
        function()
          return {
            Normal = { fg = "${palette.fg}", bg = "${palette.bg}" },
            NormalNC = { fg = "${palette.fg_muted}", bg = "${palette.bg}" },
            NormalFloat = { fg = "${palette.fg}", bg = "${palette.bg_tab_bar}" },
            FloatBorder = { fg = "${palette.line}", bg = "${palette.bg_tab_bar}" },
            FloatTitle = { fg = "${palette.mint_bright}", bg = "${palette.bg_tab_bar}", bold = true },
            Pmenu = { fg = "${palette.fg}", bg = "${palette.bg_tab_bar}" },
            PmenuSel = { fg = "${palette.fg_strong}", bg = "${palette.bg_tab_active}", bold = true },
            PmenuSbar = { bg = "${palette.bg_soft}" },
            PmenuThumb = { bg = "${palette.line}" },
            Visual = { bg = "${palette.selection}" },
            Search = { fg = "${palette.fg_strong}", bg = "${palette.peach}" },
            IncSearch = { fg = "${palette.fg_strong}", bg = "${palette.mint_bright}" },
            CurSearch = { fg = "${palette.fg_strong}", bg = "${palette.mint_bright}" },
            CursorLine = { bg = "${palette.bg_deep}" },
            CursorLineNr = { fg = "${palette.mint_bright}", bold = true },
            LineNr = { fg = "${palette.sage}" },
            Comment = { fg = "${palette.sage}", italic = true },
            Keyword = { fg = "${palette.rose}", bold = true },
            Conditional = { fg = "${palette.rose}", bold = true },
            Repeat = { fg = "${palette.rose}", bold = true },
            Function = { fg = "${palette.mint_bright}" },
            Identifier = { fg = "${palette.fg_tab}" },
            String = { fg = "${palette.aqua}" },
            Character = { fg = "${palette.aqua}" },
            Type = { fg = "${palette.mint}" },
            Constant = { fg = "${palette.peach}" },
            Number = { fg = "${palette.peach}" },
            Boolean = { fg = "${palette.peach}", bold = true },
            Special = { fg = "${palette.lemon}" },
            ["@keyword"] = { fg = "${palette.rose}", bold = true },
            ["@function"] = { fg = "${palette.mint_bright}" },
            ["@function.method"] = { fg = "${palette.mint_bright}" },
            ["@string"] = { fg = "${palette.aqua}" },
            ["@type"] = { fg = "${palette.mint}" },
            ["@variable"] = { fg = "${palette.fg_tab}" },
            ["@property"] = { fg = "${palette.fg}" },
            SignColumn = { bg = "${palette.bg}" },
            EndOfBuffer = { fg = "${palette.bg_soft}" },
            WinSeparator = { fg = "${palette.line}" },
            VertSplit = { fg = "${palette.line}" },
            StatusLine = { fg = "${palette.fg}", bg = "${palette.bg_tab_bar}" },
            StatusLineNC = { fg = "${palette.fg_muted}", bg = "${palette.bg_tab_bar}" },
            TabLineFill = { bg = "${palette.bg_tab_bar}" },
            TelescopeNormal = { fg = "${palette.fg}", bg = "${palette.bg_tab_bar}" },
            TelescopeBorder = { fg = "${palette.line}", bg = "${palette.bg_tab_bar}" },
            TelescopeTitle = { fg = "${palette.fg_strong}", bg = "${palette.bg_tab_active}", bold = true },
            TelescopePromptNormal = { fg = "${palette.fg}", bg = "${palette.bg_soft}" },
            TelescopePromptBorder = { fg = "${palette.line}", bg = "${palette.bg_soft}" },
            TelescopePromptTitle = { fg = "${palette.fg_strong}", bg = "${palette.peach}", bold = true },
            TelescopePreviewTitle = { fg = "${palette.fg_strong}", bg = "${palette.bg_tab_active}", bold = true },
            TelescopeResultsTitle = { fg = "${palette.fg_strong}", bg = "${palette.bg_tab_active}", bold = true },
            SnacksDashboardHeader = { fg = "${palette.mint_bright}" },
            SnacksDashboardDesc = { fg = "${palette.fg_muted}" },
            SnacksDashboardDir = { fg = "${palette.sage}" },
            SnacksDashboardFile = { fg = "${palette.fg}" },
            SnacksDashboardSpecial = { fg = "${palette.peach}" },
            SnacksDashboardTitle = { fg = "${palette.mint}", bold = true },
            DiagnosticVirtualTextError = { fg = "${palette.peach}", bg = "${palette.bg_tab_bar}" },
            DiagnosticVirtualTextWarn = { fg = "${palette.lemon}", bg = "${palette.bg_tab_bar}" },
            DiagnosticVirtualTextInfo = { fg = "${palette.aqua}", bg = "${palette.bg_tab_bar}" },
            DiagnosticVirtualTextHint = { fg = "${palette.mint}", bg = "${palette.bg_tab_bar}" },
            WinBar = { fg = "${palette.fg_muted}", bg = "${palette.bg_soft}" },
            WinBarNC = { fg = "${palette.sage}", bg = "${palette.bg_soft}" },
          }
        end
      '';
    };
  };

  plugins = {
    bufferline = {
      enable = true;
      settings = {
        options = {
          always_show_bufferline = true;
          numbers = "ordinal";
          separator_style = "thin";
          indicator.style = "none";
          show_buffer_close_icons = false;
          show_close_icon = false;
          show_buffer_icons = true;
          color_icons = true;
          diagnostics = "nvim_lsp";
          offsets = [
            {
              filetype = "oil";
              text = "Explorer";
              highlight = "WinBar";
              text_align = "left";
              separator = true;
            }
          ];
        };
        highlights = {
          fill.bg = palette.bg_tab_bar;
          background = {
            fg = palette.fg_muted;
            bg = palette.bg_tab;
          };
          buffer_visible = {
            fg = palette.fg_muted;
            bg = palette.bg_tab;
          };
          buffer_selected = {
            fg = palette.fg_strong;
            bg = palette.bg_tab_active;
            bold = true;
            italic = false;
          };
          numbers = {
            fg = palette.fg_muted;
            bg = palette.bg_tab;
            bold = true;
          };
          numbers_visible = {
            fg = palette.fg_muted;
            bg = palette.bg_tab;
            bold = true;
          };
          numbers_selected = {
            fg = palette.fg_strong;
            bg = palette.bg_tab_active;
            bold = true;
          };
          duplicate = {
            fg = palette.fg_muted;
            bg = palette.bg_tab;
            italic = false;
          };
          duplicate_selected = {
            fg = palette.fg_strong;
            bg = palette.bg_tab_active;
            italic = false;
          };
          separator = {
            fg = palette.bg_tab_bar;
            bg = palette.bg_tab_bar;
          };
          separator_selected = {
            fg = palette.bg_tab_bar;
            bg = palette.bg_tab_bar;
          };
          separator_visible = {
            fg = palette.bg_tab_bar;
            bg = palette.bg_tab_bar;
          };
          modified = {
            fg = palette.peach;
            bg = palette.bg_tab;
          };
          modified_selected = {
            fg = palette.peach;
            bg = palette.bg_tab_active;
          };
          hint = {
            fg = palette.sage;
            bg = palette.bg_tab;
          };
          hint_selected = {
            fg = palette.sage;
            bg = palette.bg_tab_active;
          };
          diagnostic = {
            fg = palette.fg_muted;
            bg = palette.bg_tab;
          };
          diagnostic_selected = {
            fg = palette.fg_strong;
            bg = palette.bg_tab_active;
          };
        };
      };
    };

    lualine = {
      enable = true;
      settings = {
        options = {
          theme = {
            normal = {
              a = {
                fg = palette.fg_strong;
                bg = palette.bg_tab_active;
                gui = "bold";
              };
              b = {
                fg = palette.fg;
                bg = palette.bg_tab_bar;
              };
              c = {
                fg = palette.fg_muted;
                bg = palette.bg_tab_bar;
              };
            };
            insert.a = {
              fg = palette.fg_strong;
              bg = palette.selection;
              gui = "bold";
            };
            visual.a = {
              fg = palette.fg_strong;
              bg = palette.rose;
              gui = "bold";
            };
            replace.a = {
              fg = palette.fg_strong;
              bg = palette.rose;
              gui = "bold";
            };
            command.a = {
              fg = palette.fg_strong;
              bg = palette.lemon;
              gui = "bold";
            };
            inactive = {
              a = {
                fg = palette.fg_muted;
                bg = palette.bg_tab_bar;
              };
              b = {
                fg = palette.fg_muted;
                bg = palette.bg_tab_bar;
              };
              c = {
                fg = palette.sage;
                bg = palette.bg_tab_bar;
              };
            };
          };
          component_separators = {
            left = "";
            right = "";
          };
          section_separators = {
            left = "";
            right = "";
          };
          globalstatus = true;
        };
        sections = {
          lualine_a = [
            {
              "__unkeyed-1" = "mode";
              padding = {
                left = 1;
                right = 1;
              };
            }
          ];
          lualine_b = [
            "branch"
            "diff"
          ];
          lualine_c = [
            {
              "__unkeyed-1" = "filename";
              path = 1;
              symbols = {
                modified = " ●";
                readonly = " 󰌾";
                unnamed = "[No Name]";
              };
            }
          ];
          lualine_x = [
            {
              "__unkeyed-1" = "diagnostics";
              symbols = {
                error = "E:";
                warn = "W:";
                info = "I:";
                hint = "H:";
              };
            }
            "encoding"
            "filetype"
          ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
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
            {
              __raw = ''
                function()
                  local version = vim.version()
                  return {
                    align = "center",
                    text = {
                      {
                        ("⚡ Neovim %d.%d.%d via Nixvim"):format(
                          version.major,
                          version.minor,
                          version.patch
                        ),
                        hl = "footer",
                      },
                    },
                  }
                end
              '';
            }
          ];
        };
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        quickfile.enabled = true;
      };
    };
  };

  extraFiles."lua/config/dashboard_art.lua".source = ./lua/dashboard_art.lua;
}
