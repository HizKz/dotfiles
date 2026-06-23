return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        width = 80,
        sections = {
          function()
            return require("config.dashboard_art").section()
          end,
          {
            section = "recent_files",
            title = "Recent Files",
            padding = 1,
            indent = 2,
            limit = 8,
          },
          {
            section = "projects",
            title = "Recent Projects",
            padding = 1,
            indent = 2,
            limit = 5,
          },
          { section = "startup" },
        },
      },
    },
  },
}
