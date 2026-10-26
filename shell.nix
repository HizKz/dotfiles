{
  config,
  lib,
  pkgsUnstable,
  ...
}:

let
  homeDirectory = config.home.homeDirectory;
  gitConfigPath = "${config.xdg.configHome}/git/config";
in
{
  home.sessionPath = [
    "${homeDirectory}/.cargo/bin"
    "${homeDirectory}/.bun/bin"
    "${homeDirectory}/.pyenv/bin"
  ];

  home.sessionVariables.GIT_CONFIG_GLOBAL = gitConfigPath;

  programs = {
    delta = {
      enable = true;
      package = pkgsUnstable.delta;
      enableGitIntegration = true;
      options = {
        line-numbers = true;
        navigate = true;
      };
    };

    fzf = {
      enable = true;
      package = pkgsUnstable.fzf;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      package = pkgsUnstable.git;
      includes = [
        {
          path = "${homeDirectory}/.gitconfig";
        }
      ];
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

      autosuggestion = {
        enable = true;
        strategy = [ "history" ];
      };

      syntaxHighlighting.enable = true;

      history = {
        append = true;
        size = 50000;
        save = 50000;
        ignoreDups = true;
        ignoreAllDups = true;
        saveNoDups = true;
        findNoDups = true;
        ignoreSpace = true;
        expireDuplicatesFirst = true;
        extended = true;
        share = true;
      };

      historySubstringSearch.enable = true;

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

        typeset -U path
        path=("${config.home.profileDirectory}/bin" $path)
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
            # Shell startup must not download a project's Go toolchain.
            path+=("$(GOTOOLCHAIN=local go env GOPATH)/bin")
          fi
        '')

        (lib.mkOrder 1400 ''
          source ${./zsh/project-functions.zsh}
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
