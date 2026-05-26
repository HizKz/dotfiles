-- Markdown用設定

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "md" },
  callback = function(args)
    -- markdownlint / LSP診断をこのバッファだけ無効化
    vim.diagnostic.enable(false, { bufnr = args.buf })

    -- 赤い波線対策
    vim.opt_local.spell = false

    -- Markdownを文章として読みやすくする
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.conceallevel = 2
  end,
})
