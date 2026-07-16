local markdown_ui = vim.api.nvim_create_augroup("markdown_ui", { clear = true })

local function apply_markdown_ui(bufnr)
  -- Markdown では日本語が誤検知されやすいので、波線系は抑制する
  vim.diagnostic.enable(false, { bufnr = bufnr })
  vim.opt_local.spell = false

  -- Spell 系の undercurl が残るケースを避ける
  vim.api.nvim_set_option_value("winhighlight", "SpellBad:Normal,SpellCap:Normal,SpellLocal:Normal,SpellRare:Normal", {
    scope = "local",
    win = 0,
  })

  -- Markdownを文章として読みやすくする
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
  vim.opt_local.breakindent = true
  vim.opt_local.conceallevel = 2
end

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_ui,
  pattern = "markdown",
  callback = function(args)
    apply_markdown_ui(args.buf)
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = markdown_ui,
  pattern = "*.md",
  callback = function(args)
    if vim.bo[args.buf].filetype == "markdown" then
      apply_markdown_ui(args.buf)
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = markdown_ui,
  callback = function(args)
    if vim.bo[args.buf].filetype == "markdown" then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          apply_markdown_ui(args.buf)
        end
      end)
    end
  end,
})
