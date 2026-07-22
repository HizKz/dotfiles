{ lib, ... }:

let
  silent = { silent = true; };
  noRemap = silent // { remap = false; };
  mapKey = mode: key: action: desc: {
    inherit mode key action;
    options = noRemap // { inherit desc; };
  };
  normal = mapKey "n";
in
{
  keymaps =
    [
      # The custom movement layout must stay non-recursive. Making these
      # mappings recursive creates the cycle k -> h -> n -> k.
      (mapKey [ "n" "v" ] "k" "h" "Move Left")
      (mapKey [ "n" "v" ] "t" "j" "Move Down")
      (mapKey [ "n" "v" ] "n" "k" "Move Up")
      (mapKey [ "n" "v" ] "s" "l" "Move Right")
      (mapKey [ "n" "v" ] "h" "n" "Next Search Result")
      (mapKey [ "n" "v" ] "l" "s" "Substitute Character")

      (mapKey [ "i" "x" "n" "s" ] "<C-s>" "<cmd>w<cr><esc>" "Save File")
      (mapKey "i" "jj" "<esc>" "Escape to Normal Mode")
      (normal "<esc>" "<cmd>nohlsearch<cr><esc>" "Escape and Clear Search")
      (mapKey "i" "," ",<C-g>u" "Insert Comma with Undo Break")
      (mapKey "i" "." ".<C-g>u" "Insert Period with Undo Break")
      (mapKey "i" ";" ";<C-g>u" "Insert Semicolon with Undo Break")
      (mapKey "x" "<" "<gv" "Indent Left")
      (mapKey "x" ">" ">gv" "Indent Right")

      (normal "<A-j>" "<cmd>execute 'move .+' . v:count1<cr>==" "Move Line Down")
      (normal "<A-k>" "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==" "Move Line Up")
      (mapKey "i" "<A-j>" "<esc><cmd>move .+1<cr>==gi" "Move Line Down")
      (mapKey "i" "<A-k>" "<esc><cmd>move .-2<cr>==gi" "Move Line Up")
      (mapKey "x" "<A-j>" ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv" "Move Selection Down")
      (mapKey "x" "<A-k>" ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv" "Move Selection Up")

      # Ctrl-s remains Save, so Ctrl-l is the right-window key.
      (normal "<C-k>" "<cmd>wincmd h<cr>" "Go to Left Window")
      (normal "<C-t>" "<cmd>wincmd j<cr>" "Go to Lower Window")
      (normal "<C-n>" "<cmd>wincmd k<cr>" "Go to Upper Window")
      (normal "<C-l>" "<cmd>wincmd l<cr>" "Go to Right Window")
      (normal "<C-Up>" "<cmd>resize +2<cr>" "Increase Window Height")
      (normal "<C-Down>" "<cmd>resize -2<cr>" "Decrease Window Height")
      (normal "<C-Left>" "<cmd>vertical resize -2<cr>" "Decrease Window Width")
      (normal "<C-Right>" "<cmd>vertical resize +2<cr>" "Increase Window Width")
      (normal "<leader>-" "<cmd>split<cr>" "Split Window Below")
      (normal "<leader>|" "<cmd>vsplit<cr>" "Split Window Right")
      (normal "<leader>wd" "<cmd>close<cr>" "Delete Window")

      (normal "<S-h>" "<cmd>BufferLineCyclePrev<cr>" "Previous Buffer")
      (normal "<S-l>" "<cmd>BufferLineCycleNext<cr>" "Next Buffer")
      (normal "[b" "<cmd>BufferLineCyclePrev<cr>" "Previous Buffer")
      (normal "]b" "<cmd>BufferLineCycleNext<cr>" "Next Buffer")
      (normal "[B" "<cmd>BufferLineMovePrev<cr>" "Move Buffer Left")
      (normal "]B" "<cmd>BufferLineMoveNext<cr>" "Move Buffer Right")
      (normal "<leader>bb" "<cmd>buffer #<cr>" "Switch to Other Buffer")
      (normal "<leader>`" "<cmd>buffer #<cr>" "Switch to Other Buffer")
      (normal "<leader>bd" "<cmd>lua Snacks.bufdelete()<cr>" "Delete Buffer")
      (normal "<leader>bo" "<cmd>lua Snacks.bufdelete.other()<cr>" "Delete Other Buffers")
      (normal "<leader>bi" "<cmd>lua Snacks.bufdelete.invisible()<cr>" "Delete Invisible Buffers")
      (normal "<leader>bD" "<cmd>bdelete<cr>" "Delete Buffer and Window")
      (normal "<leader>bp" "<cmd>BufferLineTogglePin<cr>" "Toggle Buffer Pin")
      (normal "<leader>bP" "<cmd>BufferLineGroupClose ungrouped<cr>" "Delete Non-Pinned Buffers")
      (normal "<leader>br" "<cmd>BufferLineCloseRight<cr>" "Delete Buffers to the Right")
      (normal "<leader>bl" "<cmd>BufferLineCloseLeft<cr>" "Delete Buffers to the Left")
      (normal "<leader>bj" "<cmd>BufferLinePick<cr>" "Pick Buffer")

      (normal "-" "<cmd>Oil<cr>" "Open Parent Directory")
      (normal "<leader>e" "<cmd>OilSidebarFocus<cr>" "Focus Explorer")
      (normal "<leader>m" "<cmd>OilMainFocus<cr>" "Focus Editor")
      (normal "<leader>fn" "<cmd>enew<cr>" "New File")
      (normal "<leader>qq" "<cmd>qa<cr>" "Quit All")
      (normal "<leader>ur" "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-l><cr>" "Redraw and Clear Search")

      (normal "[q" { __raw = "function() local ok, err = pcall(vim.cmd.cprev); if not ok then vim.notify(err, vim.log.levels.ERROR) end end"; } "Previous Quickfix Item")
      (normal "]q" { __raw = "function() local ok, err = pcall(vim.cmd.cnext); if not ok then vim.notify(err, vim.log.levels.ERROR) end end"; } "Next Quickfix Item")
      (normal "<leader>xl" { __raw = "function() local open = vim.fn.getloclist(0, { winid = 0 }).winid ~= 0; vim.cmd(open and 'lclose' or 'lopen') end"; } "Location List")
      (normal "<leader>xq" { __raw = "function() local open = vim.fn.getqflist({ winid = 0 }).winid ~= 0; vim.cmd(open and 'cclose' or 'copen') end"; } "Quickfix List")

      (normal "<leader><tab>l" "<cmd>tablast<cr>" "Last Tab")
      (normal "<leader><tab>o" "<cmd>tabonly<cr>" "Close Other Tabs")
      (normal "<leader><tab>f" "<cmd>tabfirst<cr>" "First Tab")
      (normal "<leader><tab><tab>" "<cmd>tabnew<cr>" "New Tab")
      (normal "<leader><tab>]" "<cmd>tabnext<cr>" "Next Tab")
      (normal "<leader><tab>d" "<cmd>tabclose<cr>" "Close Tab")
      (normal "<leader><tab>[" "<cmd>tabprevious<cr>" "Previous Tab")

      (normal "<leader>us" { __raw = "function() vim.opt_local.spell = not vim.opt_local.spell:get() end"; } "Toggle Spelling")
      (normal "<leader>uw" { __raw = "function() vim.opt_local.wrap = not vim.opt_local.wrap:get() end"; } "Toggle Wrap")
      (normal "<leader>uL" { __raw = "function() vim.opt_local.relativenumber = not vim.opt_local.relativenumber:get() end"; } "Toggle Relative Number")
      (normal "<leader>ul" { __raw = "function() vim.opt_local.number = not vim.opt_local.number:get() end"; } "Toggle Line Number")
      (normal "<leader>ud" { __raw = "function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end"; } "Toggle Diagnostics")
      (normal "<leader>uh" { __raw = "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 }) end"; } "Toggle Inlay Hints")
      (normal "<leader>uG" "<cmd>Gitsigns toggle_signs<cr>" "Toggle Git Signs")
      (normal "<leader>um" "<cmd>RenderMarkdown toggle<cr>" "Toggle Render Markdown")
    ]
    ++ map (i: normal "<leader>${toString i}" "<cmd>BufferLineGoToBuffer ${toString i}<cr>" "Go to Buffer ${toString i}") (lib.range 1 9);
}
