{ herdrPackage, pkgsUnstable, ... }:

{
  home = {
    username = "apple";
    homeDirectory = "/Users/apple";
    stateVersion = "26.05";

    packages = with pkgsUnstable; [
      git
      gh
      ghq
      fzf
      lazygit
      starship
      zoxide
      herdrPackage
    ];
  };

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    configFile."nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';
  };
}
