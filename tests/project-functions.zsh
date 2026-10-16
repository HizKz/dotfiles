#!/usr/bin/env zsh

set -eu

project_functions=$1
fixture_root=$TMPDIR/project-functions-fixture
first_repository="$fixture_root/first"
second_repository="$fixture_root/project space"
herdr_log=$fixture_root/herdr.log

fail() {
  print -u2 "project functions test: $*"
  exit 1
}

mkdir -p "$first_repository" "$second_repository"
: >"$herdr_log"

ghq() {
  printf '%s\n' "$first_repository" "$second_repository"
}

fzf() {
  printf '%s\n' "${FZF_SELECTION:-}"
}

herdr() {
  if [[ "$*" == "api snapshot" ]]; then
    printf '%s\n' "$HERDR_SNAPSHOT"
  elif [[ $# -eq 0 ]]; then
    printf '<attach>\n' >>"$herdr_log"
  else
    printf '%s\n' "$*" >>"$herdr_log"
  fi
}

source "$project_functions"

FZF_SELECTION=$second_repository
cproj
[[ "$PWD" == "$second_repository" ]] || fail "cproj did not enter the selected repository"

FZF_SELECTION=
previous_directory=$PWD
cproj
[[ "$PWD" == "$previous_directory" ]] || fail "cproj changed directory after cancellation"

FZF_SELECTION=$first_repository
HERDR_ENV=1
HERDR_SNAPSHOT=$(
  printf \
    '{"result":{"snapshot":{"panes":[{"cwd":"%s/src","foreground_cwd":"%s","workspace_id":"w2"}]}}}' \
    "$first_repository" \
    "$first_repository"
)
wproj
[[ "$(<"$herdr_log")" == "workspace focus w2" ]] ||
  fail "wproj did not focus the existing workspace"

: >"$herdr_log"
FZF_SELECTION=$second_repository
HERDR_SNAPSHOT='{"result":{"snapshot":{"panes":[]}}}'
wproj
[[ "$(<"$herdr_log")" == "workspace create --cwd $second_repository --label project space --focus" ]] ||
  fail "wproj did not create a workspace for the selected repository"

: >"$herdr_log"
unset HERDR_ENV
wproj
[[ "$(tail -n 1 "$herdr_log")" == "<attach>" ]] ||
  fail "wproj did not attach to Herdr from an outside shell"

print "project functions test: ok"
