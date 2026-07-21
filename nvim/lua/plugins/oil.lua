return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  config = function(_, opts)
    local oil = require("oil")
    local sidebar_group = vim.api.nvim_create_augroup("oil_sidebar_layout", { clear = true })
    local sidebar_width_ratio = 0.25
    local sidebar_min_width = 34

    oil.setup(opts)

    local function get_sidebar_target_width()
      local total_columns = vim.o.columns
      local ratio_width = math.floor(total_columns * sidebar_width_ratio)
      return math.max(sidebar_min_width, ratio_width)
    end

    local function resize_sidebar(win)
      if not win or not vim.api.nvim_win_is_valid(win) then
        return
      end

      vim.api.nvim_win_set_width(win, get_sidebar_target_width())
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
      if config.relative ~= "" then
        return false
      end

      if vim.wo[win].previewwindow then
        return false
      end

      local buf = vim.api.nvim_win_get_buf(win)
      local bt = vim.bo[buf].buftype
      local ft = vim.bo[buf].filetype

      if bt == "quickfix" or bt == "prompt" or bt == "terminal" then
        return false
      end

      if ft == "oil" then
        return false
      end

      return true
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

    local function ensure_main_window(opts_)
      opts_ = opts_ or {}
      local main_win = find_main_window()
      if main_win then
        return main_win
      end

      local sidebar_win = get_sidebar_window()
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

      local focus_win = opts_.focus_win
      if focus_win and vim.api.nvim_win_is_valid(focus_win) then
        vim.api.nvim_set_current_win(focus_win)
      elseif vim.api.nvim_win_is_valid(current_win) and current_win ~= sidebar_win then
        vim.api.nvim_set_current_win(current_win)
      else
        vim.api.nvim_set_current_win(new_win)
      end

      return new_win
    end

    local function open_sidebar(opts_)
      opts_ = opts_ or {}
      local sidebar_win = get_sidebar_window()
      if sidebar_win then
        if opts_.toggle ~= false then
          vim.api.nvim_win_close(sidebar_win, true)
        end
        return sidebar_win
      end

      local current_win = vim.api.nvim_get_current_win()
      local reuse_current = opts_.reuse_current == true and vim.bo[vim.api.nvim_win_get_buf(current_win)].filetype == "oil"

      local function finish_open()
        if not sidebar_win or not vim.api.nvim_win_is_valid(sidebar_win) then
          return
        end

        resize_sidebar(sidebar_win)
        vim.wo[sidebar_win].winfixwidth = true

        ensure_main_window()

        local main_win = find_main_window(vim.w[sidebar_win].oil_main_win)
        if opts_.focus_sidebar then
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

      if not reuse_current then
        vim.cmd("topleft vsplit")
        sidebar_win = vim.api.nvim_get_current_win()
        vim.w[sidebar_win].oil_sidebar = true
        vim.w[sidebar_win].oil_main_win = current_win

        -- Oil renders asynchronously. Keep the Oil window focused until its
        -- adapter and view are ready, then restore the editor focus.
        oil.open(vim.fn.getcwd(), nil, function()
          -- Oil invokes its ready callback through nvim_buf_call(). Defer the
          -- window change so nvim_buf_call() cannot restore the Oil window
          -- over our editor focus afterwards.
          vim.schedule(finish_open)
        end)
      else
        sidebar_win = current_win
        vim.cmd("topleft wincmd H")
        vim.w[sidebar_win].oil_sidebar = true
        vim.w[sidebar_win].oil_main_win = current_win
        finish_open()
      end

      return sidebar_win
    end

    vim.api.nvim_create_user_command("OilSidebar", function()
      open_sidebar({ toggle = true })
    end, { desc = "Toggle Oil sidebar" })

    vim.api.nvim_create_user_command("OilSidebarOpen", function()
      open_sidebar({ toggle = false, reuse_current = true })
    end, { desc = "Open Oil sidebar without toggling" })

    vim.api.nvim_create_user_command("OilSidebarFocus", function()
      local sidebar_win = get_sidebar_window()
      if not sidebar_win then
        sidebar_win = open_sidebar({ toggle = false, focus_sidebar = true })
      end

      if sidebar_win and vim.api.nvim_win_is_valid(sidebar_win) then
        vim.api.nvim_set_current_win(sidebar_win)
      end
    end, { desc = "Focus Oil sidebar" })

    vim.api.nvim_create_user_command("OilMainFocus", function()
      local sidebar_win = get_sidebar_window()
      local preferred_win = sidebar_win and vim.w[sidebar_win].oil_main_win or nil
      local main_win = find_main_window(preferred_win) or ensure_main_window()

      if main_win and vim.api.nvim_win_is_valid(main_win) then
        if sidebar_win and vim.api.nvim_win_is_valid(sidebar_win) then
          vim.w[sidebar_win].oil_main_win = main_win
        end
        vim.api.nvim_set_current_win(main_win)
      end
    end, { desc = "Focus main editor window" })

    vim.api.nvim_create_autocmd("QuitPre", {
      group = sidebar_group,
      callback = function()
        local current_win = vim.api.nvim_get_current_win()
        local sidebar_win = get_sidebar_window()

        if not sidebar_win or current_win == sidebar_win or not is_main_editor_window(current_win) then
          return
        end

        local tabpage = vim.api.nvim_get_current_tabpage()

        vim.schedule(function()
          if vim.api.nvim_get_current_tabpage() ~= tabpage then
            return
          end

          if vim.api.nvim_win_is_valid(sidebar_win) then
            vim.api.nvim_set_current_win(sidebar_win)
          end
        end)
      end,
    })

    vim.api.nvim_create_autocmd({ "WinClosed", "BufWinEnter", "TabEnter" }, {
      group = sidebar_group,
      callback = function()
        vim.schedule(function()
          local sidebar_win = get_sidebar_window()

          if not sidebar_win then
            return
          end

          resize_sidebar(sidebar_win)

          local main_win = find_main_window(vim.w[sidebar_win].oil_main_win)
          if not main_win then
            main_win = ensure_main_window({ focus_win = sidebar_win })
          end

          if main_win then
            vim.w[sidebar_win].oil_main_win = main_win
          end
        end)
      end,
    })

    vim.api.nvim_create_autocmd("VimResized", {
      group = sidebar_group,
      callback = function()
        local sidebar_win = get_sidebar_window()
        resize_sidebar(sidebar_win)
      end,
    })
  end,
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    constrain_cursor = "name",
    columns = {
      "icon",
    },
    keymaps = {
      ["<CR>"] = {
        desc = "Open entry from sidebar or enter directory",
        callback = function()
          local oil = require("oil")
          local function create_empty_buffer()
            local buf = vim.api.nvim_create_buf(true, false)
            vim.bo[buf].bufhidden = "wipe"
            vim.bo[buf].swapfile = false
            vim.bo[buf].modifiable = true
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
            vim.bo[buf].modifiable = false
            vim.bo[buf].modified = false
            vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
            return buf
          end

          local function is_main_editor_window(win)
            if not vim.api.nvim_win_is_valid(win) or vim.w[win].oil_sidebar == true then
              return false
            end

            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
              return false
            end

            if vim.wo[win].previewwindow then
              return false
            end

            local buf = vim.api.nvim_win_get_buf(win)
            local bt = vim.bo[buf].buftype
            local ft = vim.bo[buf].filetype

            if bt == "quickfix" or bt == "prompt" or bt == "terminal" then
              return false
            end

            if ft == "oil" then
              return false
            end

            return true
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

          local function ensure_main_window(sidebar_win, preferred_win)
            local main_win = find_main_window(preferred_win)
            if main_win then
              return main_win
            end

            if not sidebar_win or not vim.api.nvim_win_is_valid(sidebar_win) then
              return nil
            end

            vim.api.nvim_set_current_win(sidebar_win)
            vim.cmd("rightbelow vsplit")
            local new_win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(new_win, create_empty_buffer())
            vim.wo[new_win].number = true
            vim.wo[new_win].relativenumber = true
            vim.wo[new_win].signcolumn = "no"
            vim.wo[new_win].foldcolumn = "0"
            vim.w[sidebar_win].oil_main_win = new_win
            return new_win
          end

          local entry = oil.get_cursor_entry()
          if not entry then
            return
          end

          local current_win = vim.api.nvim_get_current_win()
          local is_sidebar = vim.w[current_win].oil_sidebar == true
          local main_win = ensure_main_window(current_win, vim.w[current_win].oil_main_win)

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
        end,
      },
    },
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name)
        return name == ".DS_Store"
      end,
    },
    win_options = {
      signcolumn = "no",
      number = false,
      relativenumber = false,
      wrap = false,
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
    },
  },
}
