{
  config,
  lib,
  pkgsUnstable,
  ...
}:

let
  homeDirectory = config.home.homeDirectory;
in
{
  home.sessionPath = [
    "${homeDirectory}/.cargo/bin"
    "${homeDirectory}/.bun/bin"
    "${homeDirectory}/.pyenv/bin"
  ];

  programs = {
    fzf = {
      enable = true;
      package = pkgsUnstable.fzf;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      package = pkgsUnstable.starship;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      package = pkgsUnstable.zoxide;
      enableZshIntegration = true;
      options = [
        "--cmd"
        "cd"
      ];
    };

    zsh = {
      enable = true;
      package = pkgsUnstable.zsh;
      dotDir = "${config.xdg.configHome}/zsh";
      autocd = false;
      enableCompletion = true;

      sessionVariables = {
        BUN_INSTALL = "${homeDirectory}/.bun";
        NVM_DIR = "${homeDirectory}/.nvm";
        PYENV_ROOT = "${homeDirectory}/.pyenv";
      };

      oh-my-zsh = {
        enable = true;
        theme = "";
        plugins = [
          "git"
          "brew"
          "bun"
          "npm"
          "pyenv"
          "gcloud"
          "golang"
        ];
      };

      profileExtra = ''
        if [[ -x /opt/homebrew/bin/brew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        if command -v pyenv >/dev/null 2>&1; then
          eval "$(pyenv init --path)"
        fi
      '';

      initContent = lib.mkMerge [
        (lib.mkOrder 850 ''
          if [[ -s "$NVM_DIR/nvm.sh" ]]; then
            source "$NVM_DIR/nvm.sh"
          fi
          if [[ -s "$NVM_DIR/bash_completion" ]]; then
            source "$NVM_DIR/bash_completion"
          fi

          if command -v go >/dev/null 2>&1; then
            path+=("$(go env GOPATH)/bin")
          fi
        '')

        (lib.mkOrder 1500 ''
          local_zsh_config="${config.xdg.configHome}/zsh/local.zsh"
          if [[ -r "$local_zsh_config" ]]; then
            source "$local_zsh_config"
          fi
          unset local_zsh_config
        '')
      ];
    };
  };
}
