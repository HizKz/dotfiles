#!/bin/sh

set -eu

repo_dir=$1
fixture_root=$TMPDIR/setup-fixture
fixture_home=$fixture_root/home

fail() {
	echo "setup test: $*" >&2
	exit 1
}

assert_link() {
	expected=$1
	actual=$2

	[ -L "$actual" ] || fail "missing link: $actual"
	[ "$(readlink "$actual")" = "$expected" ] ||
		fail "unexpected link target: $actual"
}

mkdir -p "$fixture_home"

DOTFILES_HOME=$fixture_home "$repo_dir/setup.sh" --dry-run >/dev/null
DOTFILES_HOME=$fixture_home "$repo_dir/setup.sh" >/dev/null

assert_link "$repo_dir/wezterm" "$fixture_home/.config/wezterm"
assert_link "$repo_dir/karabiner" "$fixture_home/.config/karabiner"
assert_link "$repo_dir/starship/starship.toml" "$fixture_home/.config/starship.toml"
assert_link "$repo_dir/herdr/config.toml" "$fixture_home/.config/herdr/config.toml"
assert_link "$repo_dir/lazygit/config.yml" "$fixture_home/.config/lazygit/config.yml"
assert_link \
	"$repo_dir/codex-history/config.toml" \
	"$fixture_home/Library/Application Support/codex-history/config.toml"

DOTFILES_HOME=$fixture_home "$repo_dir/setup.sh" >/dev/null
DOTFILES_HOME=$fixture_home "$repo_dir/setup.sh" --remove >/dev/null

[ ! -L "$fixture_home/.config/wezterm" ] || fail "remove left the WezTerm link"
[ -d "$fixture_home/.config/herdr" ] || fail "remove deleted the Herdr state directory"

mkdir -p "$fixture_home/.config"
touch "$fixture_home/.config/wezterm"
if DOTFILES_HOME=$fixture_home "$repo_dir/setup.sh" >/dev/null 2>&1; then
	fail "a conflicting target did not abort setup"
fi
[ ! -e "$fixture_home/.config/karabiner" ] ||
	fail "setup made partial changes after a conflict"

echo "setup test: ok"
