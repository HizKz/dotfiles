local failures = {}

local function check(condition, message)
  if not condition then
    table.insert(failures, message)
  end
end

local expected = {
  { "n", "k", "Move Left" },
  { "n", "t", "Move Down" },
  { "n", "n", "Move Up" },
  { "n", "s", "Move Right" },
  { "n", "h", "Next Search Result" },
  { "n", "l", "Substitute Character" },
  { "n", "<C-k>", "Go to Left Window" },
  { "n", "<C-t>", "Go to Lower Window" },
  { "n", "<C-n>", "Go to Upper Window" },
  { "n", "<C-l>", "Go to Right Window" },
  { "n", "<C-s>", "Save File" },
  { "n", "<leader>ff", "Find Files in Project" },
  { "n", "<leader>sg", "Grep Project" },
  { "n", "<leader>j", "Flash Jump" },
  { "n", "<leader>cf", "Format" },
  { "n", "<leader>xx", "Diagnostics" },
  { "n", "<leader>qs", "Restore Session" },
  { "n", "<leader>cp", "Toggle Markdown Preview" },
}

for _, item in ipairs(expected) do
  local mode, lhs, description = unpack(item)
  local mapping = vim.fn.maparg(lhs, mode, false, true)
  check(not vim.tbl_isempty(mapping), ("missing %s mapping %s"):format(mode, lhs))
  check(mapping.noremap == 1, ("mapping %s must be non-recursive"):format(lhs))
  check(mapping.desc == description, ("mapping %s has unexpected description"):format(lhs))
end

vim.cmd.enew()
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "abc", "def", "ghi" })
vim.api.nvim_win_set_cursor(0, { 2, 1 })

local function press(keys)
  vim.api.nvim_feedkeys(vim.keycode(keys), "mx", false)
end

press("k")
check(vim.api.nvim_win_get_cursor(0)[2] == 0, "k must move left")

press("s")
check(vim.api.nvim_win_get_cursor(0)[2] == 1, "s must move right")

press("n")
check(vim.api.nvim_win_get_cursor(0)[1] == 1, "n must move up")

press("t")
check(vim.api.nvim_win_get_cursor(0)[1] == 2, "t must move down")

vim.cmd.vsplit()
local right_window = vim.api.nvim_get_current_win()
press("<C-k>")
local left_window = vim.api.nvim_get_current_win()
check(left_window ~= right_window, "Ctrl-k must move to the left window")
press("<C-l>")
check(vim.api.nvim_get_current_win() == right_window, "Ctrl-l must move to the right window")

if #failures > 0 then
  for _, failure in ipairs(failures) do
    vim.api.nvim_err_writeln("keymap test: " .. failure)
  end
  vim.cmd("cquit 1")
end

print("keymap test: ok")
vim.cmd("qa!")
