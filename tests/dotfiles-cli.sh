#!/usr/bin/env bash

set -euo pipefail

repo_source=$1
fixture_root=$TMPDIR/dotfiles-cli-fixture
fixture_repo=$fixture_root/repository
fixture_home=$fixture_root/home
mock_bin=$fixture_root/bin
dotfiles_command=$repo_source/scripts/dotfiles
test_original_path=$PATH
test_git=$(command -v git)

fail() {
	printf 'dotfiles CLI test: %s\n' "$*" >&2
	exit 1
}

mkdir -p "$fixture_repo" "$fixture_home" "$mock_bin"

printf '%s\n' '{ description = "fixture"; }' >"$fixture_repo/flake.nix"
printf '%s\n' '{"version": 7, "root": "root", "nodes": {}}' >"$fixture_repo/flake.lock"
printf '%s\n' '#!/bin/sh' 'exit 0' >"$fixture_repo/setup.sh"
chmod +x "$fixture_repo/setup.sh"

git -C "$fixture_repo" init -q
git -C "$fixture_repo" add flake.nix flake.lock setup.sh
git -C "$fixture_repo" \
	-c user.name=Fixture \
	-c user.email=fixture@example.invalid \
	commit -qm initial

mkdir -p "$fixture_home/.config/git"
git config --file "$fixture_home/.gitconfig" user.name Fixture
git config --file "$fixture_home/.gitconfig" user.email fixture@example.invalid
git config --file "$fixture_home/.config/git/config" \
	include.path "$fixture_home/.gitconfig"
git config --file "$fixture_home/.config/git/config" \
	pager.diff /nix/store/fixture-delta/bin/delta

cp "$repo_source/tests/fixtures/nix" "$mock_bin/nix"
cp "$repo_source/tests/fixtures/home-manager" "$mock_bin/home-manager"
chmod +x "$mock_bin/nix" "$mock_bin/home-manager"
export PATH="$mock_bin:$fixture_home/.nix-profile/bin:$test_original_path"
export DOTFILES_HOME=$fixture_home
export DOTFILES_TEST_CONFIRM=y

mkdir -p "$fixture_home/.nix-profile/bin" "$fixture_home/.local/state/nix/profiles"
ln -s /nix/store/fixture-generation \
	"$fixture_home/.local/state/nix/profiles/home-manager"
for managed_command in \
	home-manager gh ghq fzf herdr lazygit nvim spotify_player starship zoxide jq dotfiles; do
	ln -s "$repo_source/tests/fixtures/managed-command" \
		"$fixture_home/.nix-profile/bin/$managed_command"
done
ln -s "$test_git" "$fixture_home/.nix-profile/bin/git"

"$dotfiles_command" --repo "$fixture_repo" doctor >/dev/null
rm "$fixture_home/.nix-profile/bin/nvim"
if "$dotfiles_command" --repo "$fixture_repo" doctor >/dev/null 2>&1; then
	fail "doctor succeeded with a missing required command"
fi
ln -s "$repo_source/tests/fixtures/managed-command" \
	"$fixture_home/.nix-profile/bin/nvim"
export PATH="$mock_bin:$test_original_path"

touch "$fixture_repo/untracked"
if "$dotfiles_command" --repo "$fixture_repo" update unstable >/dev/null 2>&1; then
	fail "update accepted a dirty worktree"
fi
rm "$fixture_repo/untracked"

"$dotfiles_command" --repo "$fixture_repo" update unstable >/dev/null
grep -q '# candidate 1' "$fixture_repo/flake.lock" ||
	fail "successful update did not replace flake.lock"

git -C "$fixture_repo" add flake.lock
git -C "$fixture_repo" \
	-c user.name=Fixture \
	-c user.email=fixture@example.invalid \
	commit -qm candidate

original_lock=$(<"$fixture_repo/flake.lock")
export DOTFILES_TEST_CANDIDATE=2
export DOTFILES_TEST_SWITCH_FAIL=1
if "$dotfiles_command" --repo "$fixture_repo" update unstable >/dev/null 2>&1; then
	fail "update succeeded after a failed Home Manager switch"
fi
[[ $(<"$fixture_repo/flake.lock") == "$original_lock" ]] ||
	fail "failed update did not restore flake.lock"

printf 'dotfiles CLI test: ok\n'
