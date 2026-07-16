# dotfiles

Personal configuration managed with [ghq](https://github.com/x-motemen/ghq)
and [GNU Stow](https://www.gnu.org/software/stow/).

## Location

```text
~/ghq/github.com/HizumeKazushi/dotfiles
```

## Setup

```sh
brew install ghq stow
ghq get -p HizumeKazushi/dotfiles
cd ~/ghq/github.com/HizumeKazushi/dotfiles
stow -t ~ nvim wezterm starship karabiner
```

Preview changes before creating links:

```sh
stow --simulate --verbose -t ~ nvim wezterm starship karabiner
```

Remove the managed links:

```sh
stow -D -t ~ nvim wezterm starship karabiner
```

Only explicitly managed configuration belongs in this repository. Do not add
application credentials such as `gh/hosts.yml` or `neonctl/credentials.json`.
