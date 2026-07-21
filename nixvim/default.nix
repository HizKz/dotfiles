{ lib, ... }:

{
  imports = [
    ./base.nix
    ./languages.nix
    ./plugins.nix
    ./legacy.nix
  ];

  wrapRc = true;
  enablePrintInit = true;

  extraConfigLuaPre = ''
    vim.fn.mkdir(vim.fn.stdpath("data"), "p")
  '';

  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "copilot.vim";
}
