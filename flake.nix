{
  description = "Hizkz's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    herdr = {
      url = "github:ogulcancelik/herdr/v0.7.4";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
  };

  outputs =
    {
      herdr,
      home-manager,
      nixvim,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgsStable = nixpkgs.legacyPackages.${system};
      pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};
      nixvimConfiguration = nixvim.lib.evalNixvim {
        inherit system;
        modules = [
          ./nixvim
          {
            extraPackages = with pkgsUnstable; [
              delve
              fd
              gofumpt
              golangci-lint
              gomodifytags
              gopls
              gotools
              impl
              prettier
              pyright
              ripgrep
              ruff
              typescript
              typescript-language-server
              vue-language-server
            ];
          }
        ];
      };
      nixvimPackage = nixvimConfiguration.config.build.package;
    in
    {
      packages.${system}.nixvim = nixvimPackage;
      checks.${system} = {
        nixvim = nixvimConfiguration.config.build.test;
        nixvim-keymaps = pkgsStable.runCommand "nixvim-keymaps-check" { } ''
          export XDG_CACHE_HOME="$TMPDIR/cache"
          export XDG_DATA_HOME="$TMPDIR/data"
          export XDG_STATE_HOME="$TMPDIR/state"
          mkdir -p "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
          ${nixvimPackage}/bin/nvim --headless -i NONE \
            -c "luafile ${./nixvim/tests/keymaps.lua}"
          touch "$out"
        '';
      };

      homeConfigurations.apple = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsStable;
        extraSpecialArgs = {
          herdrPackage = herdr.packages.aarch64-darwin.default;
          inherit nixvimPackage pkgsUnstable;
        };
        modules = [ ./home.nix ];
      };
    };
}
