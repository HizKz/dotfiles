return {
  {
    "andweeb/presence.nvim",
    lazy = false,
    config = function()
      require("presence").setup({
        auto_update = true,
        neovim_image_text = "The One True Editor",
        main_image = "neovim",
      })
    end,
  },
}
