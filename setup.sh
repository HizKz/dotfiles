#!/bin/sh

set -eu

usage() {
  cat <<'EOF'
Usage: ./setup.sh [--dry-run | --remove]

Create dotfile symlinks:
  ./setup.sh

Preview changes without modifying the filesystem:
  ./setup.sh --dry-run

Remove symlinks that point to this repository:
  ./setup.sh --remove
EOF
}

mode=apply

case "$#" in
  0) ;;
  1)
    case "$1" in
      --dry-run) mode=dry-run ;;
      --remove) mode=remove ;;
      -h | --help)
        usage
        exit 0
        ;;
      *)
        usage >&2
        exit 2
        ;;
    esac
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if [ -z "${HOME:-}" ]; then
  echo "error: HOME is not set" >&2
  exit 1
fi

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
config_dir=$HOME/.config
herdr_config_dir=$config_dir/herdr
lazygit_config_dir=$config_dir/lazygit
legacy_lazygit_config_file="$HOME/Library/Application Support/lazygit/config.yml"
codex_history_config_dir="$HOME/Library/Application Support/codex-history"
errors=0

report_conflict() {
  path=$1
  reason=$2
  echo "conflict: $path ($reason)" >&2
  errors=$((errors + 1))
}

check_config_dir() {
  if [ -L "$config_dir" ] && [ ! -d "$config_dir" ]; then
    report_conflict "$config_dir" "dangling or non-directory symlink"
  elif [ -e "$config_dir" ] && [ ! -d "$config_dir" ]; then
    report_conflict "$config_dir" "not a directory"
  fi
}

check_herdr_config_dir() {
  if [ -L "$herdr_config_dir" ]; then
    report_conflict "$herdr_config_dir" "symlink instead of a managed directory"
  elif [ -e "$herdr_config_dir" ] && [ ! -d "$herdr_config_dir" ]; then
    report_conflict "$herdr_config_dir" "not a directory"
  fi
}

check_lazygit_config_dir() {
  if [ -L "$lazygit_config_dir" ]; then
    report_conflict "$lazygit_config_dir" "symlink instead of a managed directory"
  elif [ -e "$lazygit_config_dir" ] && [ ! -d "$lazygit_config_dir" ]; then
    report_conflict "$lazygit_config_dir" "not a directory"
  fi
}

check_codex_history_config_dir() {
  if [ -L "$codex_history_config_dir" ]; then
    report_conflict "$codex_history_config_dir" "symlink instead of a managed directory"
  elif [ -e "$codex_history_config_dir" ] && [ ! -d "$codex_history_config_dir" ]; then
    report_conflict "$codex_history_config_dir" "not a directory"
  fi
}

check_source() {
  source_path=$1

  if [ ! -e "$source_path" ]; then
    echo "error: source does not exist: $source_path" >&2
    errors=$((errors + 1))
  fi
}

check_apply_target() {
  source_path=$1
  target_path=$2

  if [ -L "$target_path" ]; then
    link_value=$(readlink "$target_path")
    if [ "$link_value" = "$source_path" ]; then
      echo "unchanged: $target_path -> $source_path"
    else
      report_conflict "$target_path" "symlink points to $link_value"
    fi
  elif [ -e "$target_path" ]; then
    report_conflict "$target_path" "path already exists"
  else
    echo "create: $target_path -> $source_path"
  fi
}

check_remove_target() {
  source_path=$1
  target_path=$2

  if [ -L "$target_path" ]; then
    link_value=$(readlink "$target_path")
    if [ "$link_value" = "$source_path" ]; then
      echo "remove: $target_path"
    else
      report_conflict "$target_path" "symlink points to $link_value"
    fi
  elif [ -e "$target_path" ]; then
    report_conflict "$target_path" "not a symlink owned by this repository"
  else
    echo "absent: $target_path"
  fi
}

check_legacy_lazygit_target() {
  source_path=$1

  if [ -L "$legacy_lazygit_config_file" ] &&
    [ "$(readlink "$legacy_lazygit_config_file")" = "$source_path" ]; then
    echo "remove obsolete: $legacy_lazygit_config_file"
  fi
}

create_link() {
  source_path=$1
  target_path=$2

  if [ ! -L "$target_path" ]; then
    ln -s "$source_path" "$target_path"
  fi
}

remove_link() {
  source_path=$1
  target_path=$2

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    unlink "$target_path"
  fi
}

check_config_dir
check_herdr_config_dir
check_lazygit_config_dir
check_codex_history_config_dir

if [ "$mode" != remove ]; then
  check_source "$repo_dir/wezterm"
  check_source "$repo_dir/karabiner"
  check_source "$repo_dir/starship/starship.toml"
  check_source "$repo_dir/herdr/config.toml"
  check_source "$repo_dir/lazygit/config.yml"
  check_source "$repo_dir/codex-history/config.toml"

  check_apply_target "$repo_dir/wezterm" "$config_dir/wezterm"
  check_apply_target "$repo_dir/karabiner" "$config_dir/karabiner"
  check_apply_target "$repo_dir/starship/starship.toml" "$config_dir/starship.toml"
  check_apply_target "$repo_dir/herdr/config.toml" "$herdr_config_dir/config.toml"
  check_apply_target "$repo_dir/lazygit/config.yml" "$lazygit_config_dir/config.yml"
  check_legacy_lazygit_target "$repo_dir/lazygit/config.yml"
  check_apply_target "$repo_dir/codex-history/config.toml" "$codex_history_config_dir/config.toml"
else
  check_remove_target "$repo_dir/wezterm" "$config_dir/wezterm"
  check_remove_target "$repo_dir/karabiner" "$config_dir/karabiner"
  check_remove_target "$repo_dir/starship/starship.toml" "$config_dir/starship.toml"
  check_remove_target "$repo_dir/herdr/config.toml" "$herdr_config_dir/config.toml"
  check_remove_target "$repo_dir/lazygit/config.yml" "$lazygit_config_dir/config.yml"
  check_legacy_lazygit_target "$repo_dir/lazygit/config.yml"
  check_remove_target "$repo_dir/codex-history/config.toml" "$codex_history_config_dir/config.toml"
fi

if [ "$errors" -ne 0 ]; then
  echo "error: no changes were made because conflicts were found" >&2
  exit 1
fi

if [ "$mode" = dry-run ]; then
  echo "dry-run: no changes were made"
  exit 0
fi

if [ "$mode" = apply ]; then
  if [ ! -d "$config_dir" ]; then
    mkdir -p "$config_dir"
  fi
  if [ ! -d "$herdr_config_dir" ]; then
    mkdir -p "$herdr_config_dir"
  fi
  if [ ! -d "$lazygit_config_dir" ]; then
    mkdir -p "$lazygit_config_dir"
  fi
  if [ ! -d "$codex_history_config_dir" ]; then
    mkdir -p "$codex_history_config_dir"
  fi

  create_link "$repo_dir/wezterm" "$config_dir/wezterm"
  create_link "$repo_dir/karabiner" "$config_dir/karabiner"
  create_link "$repo_dir/starship/starship.toml" "$config_dir/starship.toml"
  create_link "$repo_dir/herdr/config.toml" "$herdr_config_dir/config.toml"
  remove_link "$repo_dir/lazygit/config.yml" "$legacy_lazygit_config_file"
  create_link "$repo_dir/lazygit/config.yml" "$lazygit_config_dir/config.yml"
  create_link "$repo_dir/codex-history/config.toml" "$codex_history_config_dir/config.toml"
  echo "setup complete"
  echo "note: restart Karabiner-Elements if karabiner settings are not reloaded"
else
  remove_link "$repo_dir/wezterm" "$config_dir/wezterm"
  remove_link "$repo_dir/karabiner" "$config_dir/karabiner"
  remove_link "$repo_dir/starship/starship.toml" "$config_dir/starship.toml"
  remove_link "$repo_dir/herdr/config.toml" "$herdr_config_dir/config.toml"
  remove_link "$repo_dir/lazygit/config.yml" "$legacy_lazygit_config_file"
  remove_link "$repo_dir/lazygit/config.yml" "$lazygit_config_dir/config.yml"
  remove_link "$repo_dir/codex-history/config.toml" "$codex_history_config_dir/config.toml"
  echo "removal complete"
fi
