#!/bin/zsh
pmset -g batt | grep -Eo "\d+%" | head -1

