#!/bin/zsh

# Configure which metrics to display
# Set to true/false to enable/disable each metric
SHOW_CPU=true
SHOW_MEMORY=true
SHOW_BATTERY=true
SHOW_DISK=false

# Icons for each metric
CPU_ICON=""
MEMORY_ICON="󰧑"
BATTERY_ICON="󱊣"
DISK_ICON=""

SEPARATOR=""

output=""

# CPU Usage
if [ "$SHOW_CPU" = true ]; then
    cpu=$(top -l 1 | grep -E "^CPU" | awk '{print $3 + $5 "%"}')
    if [ -n "$output" ]; then
        output="$output $SEPARATOR "
    fi
    output="$output#[fg=yellow]$CPU_ICON $cpu#[fg=default]"
fi

# Memory Usage
if [ "$SHOW_MEMORY" = true ]; then
    mem=$(vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages active:\s+(\d+)/ and printf("%.0f%%", $1 * $size / 1073741824 / ($(sysctl -n hw.memsize) / 1073741824) * 100);')
    if [ -z "$mem" ]; then
        # Fallback method
        mem=$(ps -A -o %mem | awk '{s+=$1} END {printf "%.0f%%", s}')
    fi
    if [ -n "$output" ]; then
        output="$output $SEPARATOR "
    fi
    output="$output#[fg=blue]$MEMORY_ICON $mem#[fg=default]"
fi

# Battery
if [ "$SHOW_BATTERY" = true ]; then
    battery=$(pmset -g batt | grep -Eo "\d+%" | head -1)
    if [ -n "$output" ]; then
        output="$output $SEPARATOR "
    fi
    output="$output#[fg=green]$BATTERY_ICON $battery#[fg=default]"
fi

# Disk Usage
if [ "$SHOW_DISK" = true ]; then
    disk=$(df -h / | awk 'NR==2 {print $5}')
    if [ -n "$output" ]; then
        output="$output $SEPARATOR "
    fi
    output="$output#[fg=magenta]$DISK_ICON $disk#[fg=default]"
fi

echo "$output"
