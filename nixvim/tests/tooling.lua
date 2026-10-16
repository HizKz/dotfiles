local failures = {}

local function check(condition, message)
  if not condition then
    table.insert(failures, message)
  end
end

local executables = {
  "bash-language-server",
  "lua-language-server",
  "nil",
  "nixfmt",
  "prettier",
  "shellcheck",
  "shfmt",
  "stylua",
  "taplo",
  "vscode-json-language-server",
  "yaml-language-server",
}

for _, executable in ipairs(executables) do
  check(vim.fn.executable(executable) == 1, ("missing executable: %s"):format(executable))
end

local servers = {
  "bashls",
  "jsonls",
  "lua_ls",
  "nil_ls",
  "taplo",
  "yamlls",
}

for _, server in ipairs(servers) do
  check(vim.lsp.config[server] ~= nil, ("missing LSP config: %s"):format(server))
end

for _, language in ipairs({ "nix", "toml" }) do
  local loaded = pcall(vim.treesitter.language.add, language)
  check(loaded, ("missing Treesitter parser: %s"):format(language))
end

if #failures > 0 then
  for _, failure in ipairs(failures) do
    vim.api.nvim_err_writeln("tooling test: " .. failure)
  end
  vim.cmd("cquit 1")
end

print("tooling test: ok")
vim.cmd("qa!")
