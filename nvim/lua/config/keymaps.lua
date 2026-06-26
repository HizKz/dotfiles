-- lua/config/keymaps.lua

local map = vim.keymap.set

-- 保存を使用しやすく
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><ESC>", { desc = "Save file" })

--移動キー
map({ "n", "v", "x" }, "k", "h", { desc = "Move Left" })
map({ "n", "v", "x" }, "t", "j", { desc = "Move Down" })
map({ "n", "v", "x" }, "n", "k", { desc = "Move Up" })
map({ "n", "v", "x" }, "s", "l", { desc = "Move Right" })

-- 2. 押し出された元の機能を、空いたキーへ「辻褄合わせ」
-- 本来の K(上), T(下), N(次を検索), S(1文字置換) を別の場所に逃がします
map({ "n", "v", "x" }, "h", "n", { desc = "Search Next" }) -- h の位置に n (Next)
map({ "n", "v", "x" }, "l", "s", { desc = "Substitute" }) -- l の位置に s (Substitute)
-- ※ K(上) と T(下) は既に N と T でカバーされているため、
--    もし独自の機能（Helpなど）を使いたい場合はここに追加します。

-- 3. 保存のショートカット（これは便利なので維持）
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><ESC>", { desc = "Save file" })

-- 4. INSERTモードEsc以外の方法[jj]
map("i", "jj", "<ESC>", { desc = "Escape to Normal Mode" })

-- Explorer / editor focus
map("n", "<leader>e", "<cmd>OilSidebarFocus<cr>", { desc = "Focus Explorer" })
map("n", "<leader>m", "<cmd>OilMainFocus<cr>", { desc = "Focus Editor" })

-- Buffer jump shortcuts like VS Code's tab selection.
for i = 1, 9 do
  map("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", {
    desc = "Go to buffer " .. i,
  })
end
