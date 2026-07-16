{
  description = "HizumeKazushi's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    {
      homeConfigurations.apple = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs.pkgsUnstable = nixpkgs-unstable.legacyPackages.aarch64-darwin;
        modules = [ ./home.nix ];
      };
    };
}
