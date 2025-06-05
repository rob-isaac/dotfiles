#!/bin/bash

CUR_SESSION=$(tmux display-message -p '#S')
RELOAD="reload(tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$CUR_SESSION\\$\")"

tmux list-sessions | sed -E 's/:.*$//' | grep -v "^$CUR_SESSION$"\
    | fzf --reverse --bind "ctrl-x:execute(tmux kill-session -t {})+$RELOAD"\
    --bind "ctrl-s:execute(bash -c 'read -p \"Name: \" name; tmux new -d -s \"\$name\"')+$RELOAD" \
    --bind "ctrl-r:$RELOAD"\
    --header 'Enter: switch session | Ctrl-X: kill session | Ctrl-S: new session | Ctrl-R: refresh list'\
    | xargs tmux switch-client -t
