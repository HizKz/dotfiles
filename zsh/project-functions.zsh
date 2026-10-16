_select_ghq_repository() {
  local query="${*:-}"
  ghq list --full-path |
    fzf \
      --query "$query" \
      --select-1 \
      --exit-0 \
      --prompt "project> " \
      --preview 'git -C {} status --short --branch'
}

cproj() {
  local repository
  repository="$(_select_ghq_repository "$@")" || return
  [[ -n "$repository" ]] || return 0
  builtin cd -- "$repository"
}

wproj() {
  local repository snapshot workspace_id
  repository="$(_select_ghq_repository "$@")" || return
  [[ -n "$repository" ]] || return 0

  if ! snapshot="$(herdr api snapshot 2>/dev/null)"; then
    print -u2 "wproj: Herdr server is not available"
    return 1
  fi

  workspace_id="$(
    printf '%s\n' "$snapshot" |
      jq -r --arg repository "$repository" '
        .result.snapshot.panes
        | map(
            select(
              (.cwd // "") == $repository
              or (.foreground_cwd // "") == $repository
              or ((.cwd // "") | startswith($repository + "/"))
              or ((.foreground_cwd // "") | startswith($repository + "/"))
            )
          )
        | sort_by(
            if (.cwd // "") == $repository
              or (.foreground_cwd // "") == $repository
            then 0
            else 1
            end
          )
        | .[0].workspace_id // empty
      '
  )"

  if [[ -n "$workspace_id" ]]; then
    herdr workspace focus "$workspace_id"
  else
    herdr workspace create \
      --cwd "$repository" \
      --label "${repository:t}" \
      --focus
  fi

  if [[ "${HERDR_ENV:-}" != 1 ]]; then
    herdr
  fi
}
