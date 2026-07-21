{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    go-nvim
    guihua-lua
    kanagawa-nvim
  ];

  extraFiles = {
    "lua/config/autocmds.lua".source = ../nvim/lua/config/autocmds.lua;
    "lua/config/dashboard_art.lua".source = ../nvim/lua/config/dashboard_art.lua;
    "lua/config/markdown.lua".source = ../nvim/lua/config/markdown.lua;
    "lua/config/palette.lua".source = ../nvim/lua/config/palette.lua;
    "lua/legacy/go.lua".source = ../nvim/lua/plugins/go_preset.lua;
    "lua/legacy/oil.lua".source = ../nvim/lua/plugins/oil.lua;
    "lua/legacy/ui.lua".source = ../nvim/lua/plugins/wezterm_concept.lua;
  };

  extraConfigLuaPost = ''
    do
      local specs = require("legacy.ui")
      local colors = specs[1]
      colors.config(nil, colors.opts)

      local bufferline_opts = {}
      specs[2].opts(nil, bufferline_opts)
      require("bufferline").setup(bufferline_opts)

      local lualine_opts = {}
      specs[3].opts(nil, lualine_opts)
      require("lualine").setup(lualine_opts)
    end

    do
      local oil = require("legacy.oil")
      oil.config(nil, oil.opts)
    end

    do
      for _, spec in ipairs(require("legacy.go")) do
        if spec[1] == "ray-x/go.nvim" then
          require("go").setup(spec.opts)
          break
        end
      end
    end

    require("config.autocmds")
    require("config.markdown")
  '';
}
