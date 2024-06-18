#!/bin/zsh
top -l 1 | grep -E "^CPU" | awk '{print $3 + $5 "%"}'
