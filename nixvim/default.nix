{ lib, ... }:

{
  imports = [
    ./base.nix
    ./keymaps.nix
    ./languages.nix
    ./oil.nix
    ./plugins.nix
    ./ui.nix
  ];

  wrapRc = true;
  enablePrintInit = true;

  extraConfigLuaPre = ''
    vim.fn.mkdir(vim.fn.stdpath("data"), "p")
  '';

  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "copilot.vim";
}
