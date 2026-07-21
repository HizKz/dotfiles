local M = {}

local oil = require("oil")
local sidebar_width_ratio = 0.25
local sidebar_min_width = 34

local function get_sidebar_target_width()
  return math.max(sidebar_min_width, math.floor(vim.o.columns * sidebar_width_ratio))
end

local function resize_sidebar(win)
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_set_width(win, get_sidebar_target_width())
  end
end

local function create_empty_buffer()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
  vim.bo[buf].modifiable = false
  vim.bo[buf].modified = false
  vim.bo[buf].filetype = ""
  vim.bo[buf].buftype = ""
  vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
  return buf
end

local function get_sidebar_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.w[win].oil_sidebar == true then
      return win
    end
  end
  return nil
end

local function is_main_editor_window(win)
  if not vim.api.nvim_win_is_valid(win) or vim.w[win].oil_sidebar == true then
    return false
  end

  local config = vim.api.nvim_win_get_config(win)
  if config.relative ~= "" or vim.wo[win].previewwindow then
    return false
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local buftype = vim.bo[buf].buftype
  local filetype = vim.bo[buf].filetype
  if buftype == "quickfix" or buftype == "prompt" or buftype == "terminal" then
    return false
  end
  return filetype ~= "oil"
end

local function find_main_window(preferred_win)
  if preferred_win and is_main_editor_window(preferred_win) then
    return preferred_win
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_main_editor_window(win) then
      return win
    end
  end
  return nil
end

local function ensure_main_window(opts)
  opts = opts or {}
  local main_win = find_main_window(opts.preferred_win)
  if main_win then
    return main_win
  end

  local sidebar_win = opts.sidebar_win or get_sidebar_window()
  if not sidebar_win or not vim.api.nvim_win_is_valid(sidebar_win) then
    return nil
  end

  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(sidebar_win)
  vim.cmd("rightbelow vsplit")
  local new_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(new_win, create_empty_buffer())
  vim.wo[new_win].number = true
  vim.wo[new_win].relativenumber = true
  vim.wo[new_win].signcolumn = "no"
  vim.wo[new_win].foldcolumn = "0"
  vim.wo[new_win].cursorline = false
  vim.wo[new_win].winfixwidth = false
  vim.w[sidebar_win].oil_main_win = new_win

  if opts.focus_win and vim.api.nvim_win_is_valid(opts.focus_win) then
    vim.api.nvim_set_current_win(opts.focus_win)
  elseif vim.api.nvim_win_is_valid(current_win) and current_win ~= sidebar_win then
    vim.api.nvim_set_current_win(current_win)
  else
    vim.api.nvim_set_current_win(new_win)
  end

  return new_win
end

local function open_sidebar(opts)
  opts = opts or {}
  local sidebar_win = get_sidebar_window()
  if sidebar_win then
    if opts.toggle ~= false then
      vim.api.nvim_win_close(sidebar_win, true)
    end
    return sidebar_win
  end

  local current_win = vim.api.nvim_get_current_win()
  local reuse_current = opts.reuse_current == true and vim.bo[vim.api.nvim_win_get_buf(current_win)].filetype == "oil"

  local function finish_open()
    if not sidebar_win or not vim.api.nvim_win_is_valid(sidebar_win) then
      return
    end

    resize_sidebar(sidebar_win)
    vim.wo[sidebar_win].winfixwidth = true
    ensure_main_window({ sidebar_win = sidebar_win })

    local main_win = find_main_window(vim.w[sidebar_win].oil_main_win)
    if opts.focus_sidebar then
      vim.api.nvim_set_current_win(sidebar_win)
    elseif reuse_current and main_win then
      vim.w[sidebar_win].oil_main_win = main_win
      vim.api.nvim_set_current_win(main_win)
    elseif vim.api.nvim_win_is_valid(current_win) then
      vim.api.nvim_set_current_win(current_win)
    elseif main_win then
      vim.api.nvim_set_current_win(main_win)
    end
  end

  if reuse_current then
    sidebar_win = current_win
    vim.cmd("topleft wincmd H")
    vim.w[sidebar_win].oil_sidebar = true
    vim.w[sidebar_win].oil_main_win = current_win
    finish_open()
  else
    vim.cmd("topleft vsplit")
    sidebar_win = vim.api.nvim_get_current_win()
    vim.w[sidebar_win].oil_sidebar = true
    vim.w[sidebar_win].oil_main_win = current_win
    oil.open(vim.fn.getcwd(), nil, function()
      vim.schedule(finish_open)
    end)
  end

  return sidebar_win
end

function M.select_entry()
  local entry = oil.get_cursor_entry()
  if not entry then
    return
  end

  local current_win = vim.api.nvim_get_current_win()
  local is_sidebar = vim.w[current_win].oil_sidebar == true
  local main_win = ensure_main_window({
    sidebar_win = current_win,
    preferred_win = vim.w[current_win].oil_main_win,
  })

  if is_sidebar and main_win then
    vim.w[current_win].oil_main_win = main_win
    local dir = oil.get_current_dir()
    local path = dir and vim.fs.joinpath(dir, entry.name) or nil
    if path and vim.fn.isdirectory(path) == 0 then
      vim.api.nvim_win_call(main_win, function()
        vim.cmd.edit(vim.fn.fnameescape(path))
      end)
      vim.api.nvim_set_current_win(main_win)
      return
    end
  end

  require("oil.actions").select.callback()
end

function M.setup()
  local layout_group = vim.api.nvim_create_augroup("oil_sidebar_layout", { clear = true })
  local ui_group = vim.api.nvim_create_augroup("oil_sidebar_ui", { clear = true })
  local startup_handled = false

  local function handle_startup()
    if startup_handled then
      return
    end
    startup_handled = true

    vim.schedule(function()
      if vim.fn.argc() == 0 or vim.bo.filetype == "snacks_dashboard" then
        return
      end
      local started_in_oil = vim.bo.filetype == "oil"
      if started_in_oil then
        open_sidebar({ toggle = false, reuse_current = true })
        vim.schedule(function()
          vim.cmd("OilSidebarFocus")
        end)
      else
        open_sidebar({ toggle = true })
      end
    end)
  end

  vim.api.nvim_create_user_command("OilSidebar", function()
    open_sidebar({ toggle = true })
  end, { desc = "Toggle Oil sidebar", force = true })

  vim.api.nvim_create_user_command("OilSidebarOpen", function()
    open_sidebar({ toggle = false, reuse_current = true })
  end, { desc = "Open Oil sidebar without toggling", force = true })

  vim.api.nvim_create_user_command("OilSidebarFocus", function()
    local sidebar_win = get_sidebar_window() or open_sidebar({ toggle = false, focus_sidebar = true })
    if sidebar_win and vim.api.nvim_win_is_valid(sidebar_win) then
      vim.api.nvim_set_current_win(sidebar_win)
    end
  end, { desc = "Focus Oil sidebar", force = true })

  vim.api.nvim_create_user_command("OilMainFocus", function()
    local sidebar_win = get_sidebar_window()
    local preferred_win = sidebar_win and vim.w[sidebar_win].oil_main_win or nil
    local main_win = find_main_window(preferred_win) or ensure_main_window({ sidebar_win = sidebar_win })
    if main_win and vim.api.nvim_win_is_valid(main_win) then
      if sidebar_win and vim.api.nvim_win_is_valid(sidebar_win) then
        vim.w[sidebar_win].oil_main_win = main_win
      end
      vim.api.nvim_set_current_win(main_win)
    end
  end, { desc = "Focus main editor window", force = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = ui_group,
    pattern = "oil",
    callback = function(event)
      local dir = oil.get_current_dir(event.buf)
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
    group = ui_group,
    callback = handle_startup,
  })

  if vim.v.vim_did_enter == 1 then
    handle_startup()
  end

  vim.api.nvim_create_autocmd("User", {
    group = ui_group,
    pattern = "SnacksDashboardOpened",
    callback = function()
      local sidebar_win = get_sidebar_window()
      if sidebar_win then
        vim.api.nvim_win_close(sidebar_win, true)
      end
    end,
  })

  vim.api.nvim_create_autocmd("QuitPre", {
    group = layout_group,
    callback = function()
      local current_win = vim.api.nvim_get_current_win()
      local sidebar_win = get_sidebar_window()
      if not sidebar_win or current_win == sidebar_win or not is_main_editor_window(current_win) then
        return
      end

      local tabpage = vim.api.nvim_get_current_tabpage()
      vim.schedule(function()
        if vim.api.nvim_get_current_tabpage() == tabpage and vim.api.nvim_win_is_valid(sidebar_win) then
          vim.api.nvim_set_current_win(sidebar_win)
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd({ "WinClosed", "BufWinEnter", "TabEnter" }, {
    group = layout_group,
    callback = function()
      vim.schedule(function()
        local sidebar_win = get_sidebar_window()
        if not sidebar_win then
          return
        end
        resize_sidebar(sidebar_win)
        local main_win = find_main_window(vim.w[sidebar_win].oil_main_win)
          or ensure_main_window({ sidebar_win = sidebar_win, focus_win = sidebar_win })
        if main_win then
          vim.w[sidebar_win].oil_main_win = main_win
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd("VimResized", {
    group = layout_group,
    callback = function()
      resize_sidebar(get_sidebar_window())
    end,
  })
end

return M
