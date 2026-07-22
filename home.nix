{
  herdrPackage,
  nixvimPackage,
  pkgsUnstable,
  ...
}:

let
  spotifyPlayer =
    (pkgsUnstable.spotify-player.override {
      # The full Darwin feature set makes cctools ld abort while linking 0.24.0.
      # Keep the TUI, OAuth, Spotify Connect, cover image, and CoreAudio streaming features.
      withDaemon = false;
      withFuzzy = false;
      withImage = true;
      withMediaControl = false;
      withNotify = false;
      withSixel = false;
    }).overrideAttrs
      (old: {
        patches =
          (old.patches or [ ])
          ++ [
            ./patches/spotify-player-preserve-web-api-token.patch
            ./patches/spotify-player-force-kitty-in-herdr.patch
          ];
        postPatch =
          (old.postPatch or "")
          + ''
            patch -d "$cargoDepsCopy/source-registry-0/rspotify-0.15.3" -p1 \
              < ${./patches/rspotify-preserve-refresh-token.patch}
          '';
      });
in
{
  imports = [ ./shell.nix ];

  home = {
    username = "apple";
    homeDirectory = "/Users/apple";
    stateVersion = "26.05";

    packages = with pkgsUnstable; [
      git
      gh
      ghq
      lazygit
      nixvimPackage
      spotifyPlayer
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
