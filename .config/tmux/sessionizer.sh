#!/bin/bash

# 1. Get the current session name to exclude it
current_session=$(tmux display-message -p '#S')

# 2. Get MRU session list, filter out current session, then clean up names
session_list=$(tmux list-sessions -F "#{session_last_attached} #S" |
  sort -nr |
  awk '{print $2}' |
  grep -v "^${current_session}$")

# 3. Run fzf with Switch, Create, and Kill logic
res=$(echo "$session_list" | fzf --reverse --print-query \
  --header="Jump to/Create Session  |  [Ctrl-x] Kill Session" \
  --preview="tmux capture-pane -pt {}" \
  --preview-window="right:60%:wrap" \
  --bind "ctrl-x:execute(tmux kill-session -t {})+reload(tmux list-sessions -F '#{session_last_attached} #S' | sort -nr | awk '{print \$2}' | grep -v '^${current_session}$' )")

# Exit if cancelled
[ -z "$res" ] && exit 0

# Extract query and selection
query=$(echo "$res" | head -n1)
sel=$(echo "$res" | tail -n1)
target=${sel:-$query}

if [ -n "$target" ]; then
  # Create if it doesn't exist
  tmux has-session -t "$target" 2>/dev/null || tmux new-session -d -s "$target"
  # Switch to the session
  tmux switch-client -t "$target"
fi
