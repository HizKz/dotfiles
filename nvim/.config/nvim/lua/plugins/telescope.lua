return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function(_, opts)
    local telescope = require("telescope")

    opts.extensions = {
      file_browser = {
        theme = "ivy",
        hijack_netrw = true,
      },
    }
    telescope.setup(opts)
    telescope.load_extension("file_browser")
  end,
}
