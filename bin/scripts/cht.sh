#! /usr/bin/env bash

languages=$(echo "ruby typescript rust cpp golang c javascript aws" | tr " " "\n")
core_utils=$(echo "find xargs sed awk" | tr " " "\n")

selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "Input Query: " query

if echo "$languages" | grep -qs $selected; then
    tmux split-window -h -p 82  bash -c "curl cht.sh/$selected/$(echo "$query" | tr " " "+") | less"
else
    tmux split-window -h -p 82  bash -c "curl cht.sh/$selected~$query | less"
fi
