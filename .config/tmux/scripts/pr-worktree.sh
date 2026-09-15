#!/usr/bin/env bash
# Shared helpers for opening a PR in a git worktree and switching tmux to it.
# Sourced by select-pr-review and select-notifications.

worktree_for_branch() {
  local repo="$1" branch="$2"
  git -C "$repo" worktree list --porcelain 2>/dev/null | awk -v branch="$branch" '
    /^worktree / { path = substr($0, 10) }
    /^branch refs\/heads\// {
      current = substr($0, 8)
      sub(/^refs\/heads\//, "", current)
      if (current == branch) {
        print path
        exit
      }
    }
  '
}

worktree_for_pr() {
  local repo="$1" pr_number="$2"
  local suffix="-pr-${pr_number}"
  git -C "$repo" worktree list --porcelain 2>/dev/null | awk -v suffix="$suffix" '
    /^worktree / {
      path = substr($0, 10)
      if (substr(path, length(path) - length(suffix) + 1) == suffix) {
        print path
        exit
      }
    }
  '
}

display_error() {
  tmux display-message "$1"
}

sanitize_branch() {
  printf '%s' "$1" | tr '/:' '-'
}

ensure_pr_worktree() {
  local repo_path="$1" repo_slug="$2" pr_number="$3" head_ref="$4"
  local local_branch worktree_path existing err_file

  if [[ -z "$head_ref" ]]; then
    head_ref="$(gh pr view "$pr_number" -R "$repo_slug" --json headRefName -q .headRefName)" \
      || {
        display_error "Failed to load PR #${pr_number}"
        return 1
      }
  fi

  local_branch="$head_ref"
  worktree_path="${repo_path}/$(sanitize_branch "$head_ref")"
  err_file="$(mktemp)"

  existing="$(worktree_for_branch "$repo_path" "$local_branch")"
  [[ -n "$existing" ]] || existing="$(worktree_for_pr "$repo_path" "$pr_number")"
  if [[ -z "$existing" && -d "$worktree_path" ]]; then
    existing="$worktree_path"
  fi

  if [[ -n "$existing" && -d "$existing" ]]; then
    rm -f "$err_file"
    printf '%s' "$existing"
    return 0
  fi

  echo "Creating worktree ${local_branch}..." >&2

  if [[ -e "$worktree_path" ]]; then
    rm -f "$err_file"
    display_error "Path exists but is not a git worktree: ${worktree_path}"
    return 1
  fi

  if git -C "$repo_path" show-ref --verify --quiet "refs/heads/${local_branch}"; then
    if ! git -C "$repo_path" worktree add -q "$worktree_path" "$local_branch" >/dev/null 2>"$err_file"; then
      existing="$(worktree_for_branch "$repo_path" "$local_branch")"
      if [[ -n "$existing" && -d "$existing" ]]; then
        rm -f "$err_file"
        printf '%s' "$existing"
        return 0
      fi
      display_error "Failed to create worktree: $(tr '\n' ' ' <"$err_file")"
      rm -f "$err_file"
      return 1
    fi
    rm -f "$err_file"
    printf '%s' "$worktree_path"
    return 0
  fi

  if ! git -C "$repo_path" fetch -q origin "pull/${pr_number}/head:${local_branch}" 2>"$err_file"; then
    existing="$(worktree_for_branch "$repo_path" "$local_branch")"
    if [[ -n "$existing" && -d "$existing" ]]; then
      rm -f "$err_file"
      printf '%s' "$existing"
      return 0
    fi
    display_error "Failed to fetch PR #${pr_number}"
    rm -f "$err_file"
    return 1
  fi
  if ! git -C "$repo_path" worktree add -q "$worktree_path" "$local_branch" >/dev/null 2>"$err_file"; then
    display_error "Failed to create worktree: $(tr '\n' ' ' <"$err_file")"
    rm -f "$err_file"
    return 1
  fi
  rm -f "$err_file"
  printf '%s' "$worktree_path"
}

open_pr_in_worktree() {
  local repo_path="$1" repo_slug="$2" pr_number="$3" head_ref="${4:-}"
  local worktree target base_name suffix

  echo "Opening ${repo_slug}#${pr_number}..." >&2
  worktree="$(ensure_pr_worktree "$repo_path" "$repo_slug" "$pr_number" "$head_ref")"
  [[ -n "$worktree" && -d "$worktree" ]] || return 1

  target="$(
    tmux list-sessions -F '#{session_name}	#{@worktree_path}	#{@pr_number}	#{@pr_repo}	#{session_path}' |
      awk -F '\t' -v path="$worktree" -v pr="$pr_number" -v slug="$repo_slug" '
        $2 == path || $5 == path || ($3 == pr && $4 == slug) { print $1; exit }
      '
  )"

  if [[ -z "$target" ]]; then
    base_name="${worktree//[.:]/_}"
    target="$base_name"
    suffix=2
    while tmux has-session -t "=$target" 2>/dev/null; do
      target="${base_name}-${suffix}"
      ((suffix += 1))
    done
    tmux new-session -d -s "$target" -c "$worktree"
  fi

  tmux set-option -t "=$target:" @worktree_path "$worktree"
  tmux set-option -t "=$target:" @pr_number "$pr_number"
  tmux set-option -t "=$target:" @pr_repo "$repo_slug"

  # Popup teardown races with switch-client (especially after creating a new
  # session). Switch now and again after the popup client is gone.
  tmux switch-client -t "=$target" 2>/dev/null || true
  (
    sleep 0.15
    tmux switch-client -t "=$target"
  ) >/dev/null 2>&1 &
}
