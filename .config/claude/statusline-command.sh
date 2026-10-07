#!/bin/bash
# Approximates Powerlevel10k layout: os_icon, dir, vcs; plus model and context usage.
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

dir="${cwd/#$HOME/~}"

branch=""; dirty=""
if git -C "$cwd" --no-optional-locks rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ] && dirty="*"
fi

printf '\033[36m%s\033[0m' "$dir"
[ -n "$branch" ] && printf ' \033[32m\xee\x82\xa0 %s%s\033[0m' "$branch" "$dirty"
printf ' \033[35m%s\033[0m' "$model"
[ -n "$used" ] && printf ' \033[33mctx %.0f%%\033[0m' "$used"
printf '\n'
