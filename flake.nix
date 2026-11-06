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

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      herdrPackage = herdr.packages.${system}.default;
      nixvimConfiguration = nixvim.lib.evalNixvim {
        inherit system;
        modules = [
          ./nixvim
          {
            nixpkgs.source = nixpkgs.outPath;
            extraPackages = with pkgsUnstable; [
              bash-language-server
              delve
              fd
              gofumpt
              golangci-lint
              gomodifytags
              gopls
              gotools
              impl
              lua-language-server
              nil
              nixfmt
              prettier
              pyright
              ripgrep
              ruff
              shellcheck
              shfmt
              stylua
              taplo
              typescript
              typescript-language-server
              vscode-langservers-extracted
              vue-language-server
              yaml-language-server
            ];
          }
        ];
      };
      nixvimPackage = nixvimConfiguration.config.build.package;
      dotfilesCli = pkgsStable.writeShellApplication {
        name = "dotfiles";
        runtimeInputs = [
          pkgsStable.coreutils
          pkgsStable.gnugrep
          pkgsStable.gnutar
          pkgsStable.nix
          pkgsUnstable.ghq
          pkgsUnstable.git
        ];
        text = builtins.readFile ./scripts/dotfiles;
      };
      marpTerminal = pkgsStable.writeShellApplication {
        name = "marp-terminal";
        runtimeInputs = with pkgsUnstable; [
          marp-cli
          timg
        ];
        text = ''
          if [ "$#" -ne 1 ]; then
            echo "Usage: marp-terminal SLIDES.md" >&2
            exit 2
          fi
          if [ ! -f "$1" ]; then
            echo "marp-terminal: file not found: $1" >&2
            exit 1
          fi
          if [ ! -t 0 ] || [ ! -t 1 ]; then
            echo "marp-terminal: an interactive terminal is required" >&2
            exit 1
          fi
          slide_dir=$(mktemp -d)
          trap 'rm -rf "$slide_dir"' EXIT
          marp --allow-local-files --images png --image-scale 2 "$1" -o "$slide_dir/slide.png"
          set -- "$slide_dir"/slide.*.png
          if [ ! -f "$1" ]; then
            echo "marp-terminal: no slides were generated" >&2
            exit 1
          fi
          slides=("$@")
          index=0
          tty_state=$(stty -g)
          stty -echo -icanon min 1 time 0
          printf '\033[?1049h\033[?25l'
          cleanup() {
            if [ "''${HERDR_ENV:-}" = 1 ] && [ "''${TERM_PROGRAM:-}" = WezTerm ]; then
              printf '\033_Ga=d,d=A,q=2;\033\134'
            fi
            printf '\033[2J\033[H\033[?25h\033[?1049l'
            stty "$tty_state"
            rm -rf "$slide_dir"
          }
          trap cleanup EXIT
          image_protocol=()
          if [ "''${HERDR_ENV:-}" = 1 ] && [ "''${TERM_PROGRAM:-}" = WezTerm ]; then
            image_protocol=(-pk)
          fi
          while :; do
            read -r rows columns < <(stty size)
            if (( rows < 3 || columns < 1 )); then
              echo "marp-terminal: terminal is too small" >&2
              exit 1
            fi
            if [ "''${#image_protocol[@]}" -gt 0 ]; then
              printf '\033_Ga=d,d=A,q=2;\033\134'
            fi
            timg "''${image_protocol[@]}" -E --clear --center --upscale \
              -g "''${columns}x$((rows - 2))" --frames=1 "''${slides[$index]}"
            printf '\n  %d / %d   ← previous  → / Enter next  Esc / q exit' \
              "$((index + 1))" "''${#slides[@]}"
            key=
            IFS= read -rsn1 key || break
            case "$key" in
              "")
                if (( index + 1 < ''${#slides[@]} )); then index=$((index + 1)); fi
                ;;
              q) break ;;
              $'\033')
                sequence=
                IFS= read -rsn1 -t 0.15 sequence || break
                if [ "$sequence" = '[' ] || [ "$sequence" = 'O' ]; then
                  IFS= read -rsn1 -t 0.15 sequence || continue
                  case "$sequence" in
                    C) if (( index + 1 < ''${#slides[@]} )); then index=$((index + 1)); fi ;;
                    D) if (( index > 0 )); then index=$((index - 1)); fi ;;
                    2)
                      IFS= read -rsn1 -t 0.15 sequence || continue
                      if [ "$sequence" = 7 ]; then
                        IFS= read -rsn1 -t 0.15 sequence || continue
                        if [ "$sequence" = u ]; then break; fi
                      fi
                      ;;
                  esac
                fi
                ;;
            esac
          done
        '';
      };
      homeConfiguration = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsStable;
        extraSpecialArgs = {
          inherit
            dotfilesCli
            herdrPackage
            marpTerminal
            nixvimPackage
            pkgsUnstable
            ;
        };
        modules = [ ./home.nix ];
      };
      mkDotfilesApp =
        subcommand:
        let
          launcher = pkgsStable.writeShellScript "dotfiles-${subcommand}" ''
            exec ${dotfilesCli}/bin/dotfiles ${subcommand} "$@"
          '';
        in
        {
          type = "app";
          program = "${launcher}";
          meta.description = "Run dotfiles ${subcommand}";
        };
    in
    {
      packages.${system} = {
        dotfiles = dotfilesCli;
        nixvim = nixvimPackage;
      };

      apps.${system} = {
        check = mkDotfilesApp "check";
        doctor = mkDotfilesApp "doctor";
        update = mkDotfilesApp "update";
      };

      checks.${system} = {
        home-activation = homeConfiguration.activationPackage;
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
        nixvim-tooling = pkgsStable.runCommand "nixvim-tooling-check" { } ''
          export XDG_CACHE_HOME="$TMPDIR/cache"
          export XDG_DATA_HOME="$TMPDIR/data"
          export XDG_STATE_HOME="$TMPDIR/state"
          mkdir -p "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
          ${nixvimPackage}/bin/nvim --headless -i NONE \
            -c "luafile ${./nixvim/tests/tooling.lua}"
          touch "$out"
        '';
        nixvim-package = nixvimPackage;
        repository-format =
          pkgsStable.runCommand "dotfiles-repository-format-check"
            {
              nativeBuildInputs = with pkgsUnstable; [
                deadnix
                jq
                lychee
                nixfmt
                shellcheck
                shfmt
                statix
                stylua
                taplo
                yamllint
                zsh
              ];
            }
            ''
              cp -R ${./.} repository
              chmod -R u+w repository
              cd repository

              sh -n setup.sh karabiner/add-o24-keyboard.sh
              zsh -n zsh/project-functions.zsh tests/project-functions.zsh
              shellcheck \
                setup.sh \
                karabiner/add-o24-keyboard.sh \
                scripts/dotfiles \
                tests/setup.sh \
                tests/dotfiles-cli.sh \
                tests/fixtures/nix \
                tests/fixtures/home-manager \
                tests/fixtures/managed-command
              shfmt -d \
                setup.sh \
                karabiner/add-o24-keyboard.sh \
                scripts/dotfiles \
                tests/setup.sh \
                tests/dotfiles-cli.sh \
                tests/fixtures/nix \
                tests/fixtures/home-manager \
                tests/fixtures/managed-command

              find karabiner -name '*.json' -type f -exec jq empty {} +
              taplo check .stylua.toml herdr/config.toml codex-history/config.toml
              yamllint -c .yamllint.yml .yamllint.yml lazygit/config.yml
              stylua --check \
                wezterm/wezterm.lua \
                wezterm/keybinds.lua \
                nixvim/lua/oil_sidebar.lua \
                nixvim/lua/markdown.lua \
                nixvim/tests/keymaps.lua \
                nixvim/tests/tooling.lua

              find . -name '*.nix' -type f -exec nixfmt --check {} +
              statix check .
              deadnix --fail .
              find . -name '*.md' -type f -print0 |
                xargs -0 lychee --offline --no-progress

              touch "$out"
            '';
        setup = pkgsStable.runCommand "dotfiles-setup-check" { } ''
          export TMPDIR="$PWD/tmp"
          mkdir -p "$TMPDIR"
          ${pkgsStable.dash}/bin/dash ${./tests/setup.sh} ${./.}
          touch "$out"
        '';
        dotfiles-cli =
          pkgsStable.runCommand "dotfiles-cli-check"
            {
              nativeBuildInputs = [
                pkgsStable.bash
                pkgsStable.coreutils
                pkgsStable.git
                pkgsStable.gnutar
              ];
            }
            ''
              export TMPDIR="$PWD/tmp"
              mkdir -p "$TMPDIR"
              ${pkgsStable.bash}/bin/bash ${./tests/dotfiles-cli.sh} ${./.}
              touch "$out"
            '';
        project-functions =
          pkgsStable.runCommand "project-functions-check"
            {
              nativeBuildInputs = [
                pkgsStable.coreutils
                pkgsUnstable.jq
                pkgsUnstable.zsh
              ];
            }
            ''
              export TMPDIR="$PWD/tmp"
              mkdir -p "$TMPDIR"
              zsh ${./tests/project-functions.zsh} ${./zsh/project-functions.zsh}
              touch "$out"
            '';
      };

      devShells.${system}.default = pkgsStable.mkShell {
        packages = with pkgsUnstable; [
          deadnix
          jq
          lychee
          nixfmt
          shellcheck
          shfmt
          statix
          stylua
          taplo
          yamllint
          zsh
        ];
      };

      homeConfigurations.apple = homeConfiguration;
    };
}
