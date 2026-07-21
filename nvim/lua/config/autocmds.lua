-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local oil_sidebar = vim.api.nvim_create_augroup("oil_sidebar_ui", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = oil_sidebar,
  pattern = "oil",
  callback = function(event)
    local ok, oil = pcall(require, "oil")
    local dir = ok and oil.get_current_dir(event.buf) or nil
    vim.bo[event.buf].buflisted = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statuscolumn = ""
    vim.opt_local.wrap = false
    vim.opt_local.cursorline = true
    vim.opt_local.winbar = dir and ("  " .. vim.fn.fnamemodify(dir, ":~")) or "  Explorer"
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = oil_sidebar,
  callback = function()
    vim.schedule(function()
      -- Keep the startup dashboard full-width. Oil is still available on
      -- demand via <leader>e, and opens automatically for explicit paths.
      if vim.fn.argc() == 0 or vim.bo.filetype == "snacks_dashboard" then
        return
      end

      local started_in_oil = vim.bo.filetype == "oil"

      if started_in_oil and vim.fn.exists(":OilSidebarOpen") == 2 then
        vim.cmd("OilSidebarOpen")
      elseif vim.fn.exists(":OilSidebar") == 2 then
        vim.cmd("OilSidebar")
      end

      if started_in_oil and vim.fn.exists(":OilSidebarFocus") == 2 then
        vim.schedule(function()
          vim.cmd("OilSidebarFocus")
        end)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = oil_sidebar,
  pattern = "SnacksDashboardOpened",
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) and vim.w[win].oil_sidebar == true then
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})
