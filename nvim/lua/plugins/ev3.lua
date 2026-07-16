return {
  {
    "KWSmit/nvim-ev3.nvim",
    dependencies = { "akinsho/toggleterm.nvim" },
    opts = {
      ev3_address = "ev3dev.local",
      ev3_user = "robot",
      ev3_password = "maker",
      remote_dir = "/home/robot/pybricks_projects",
    },
    -- キーマップの設定
    keys = {
      { "<leader>er", ":EV3Run<CR>", desc = "EV3 Run" },
      { "<leader>eb", ":EV3Battery<CR>", desc = "EV3 Battery" },
    },
  },
}
