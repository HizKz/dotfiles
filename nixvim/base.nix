{ lib, ... }:

let
  moveModes = [
    "n"
    "v"
    "x"
  ];
  silent = { silent = true; };
in
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };

  opts = {
    number = true;
    relativenumber = true;
    scrolloff = 8;
    splitright = true;
    splitbelow = true;
    updatetime = 250;
    clipboard = "unnamedplus";
    timeoutlen = 300;
    undofile = true;
    termguicolors = true;
    signcolumn = "yes";
  };

  keymaps =
    [
      {
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options = silent // { desc = "Save file"; };
      }
      {
        mode = moveModes;
        key = "k";
        action = "h";
        options = { desc = "Move Left"; remap = true; };
      }
      {
        mode = moveModes;
        key = "t";
        action = "j";
        options = { desc = "Move Down"; remap = true; };
      }
      {
        mode = moveModes;
        key = "n";
        action = "k";
        options = { desc = "Move Up"; remap = true; };
      }
      {
        mode = moveModes;
        key = "s";
        action = "l";
        options = { desc = "Move Right"; remap = true; };
      }
      {
        mode = moveModes;
        key = "h";
        action = "n";
        options = { desc = "Search Next"; remap = true; };
      }
      {
        mode = moveModes;
        key = "l";
        action = "s";
        options = { desc = "Substitute"; remap = true; };
      }
      {
        mode = "i";
        key = "jj";
        action = "<esc>";
        options = { desc = "Escape to Normal Mode"; };
      }
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<cr>";
        options = silent // { desc = "Open parent directory"; };
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>OilSidebarFocus<cr>";
        options = silent // { desc = "Focus Explorer"; };
      }
      {
        mode = "n";
        key = "<leader>m";
        action = "<cmd>OilMainFocus<cr>";
        options = silent // { desc = "Focus Editor"; };
      }
    ]
    ++ map (i: {
      mode = "n";
      key = "<leader>${toString i}";
      action = "<cmd>BufferLineGoToBuffer ${toString i}<cr>";
      options = silent // { desc = "Go to buffer ${toString i}"; };
    }) (lib.range 1 9);
}
