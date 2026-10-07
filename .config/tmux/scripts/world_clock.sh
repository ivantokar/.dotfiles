#!/bin/zsh

# Configure your timezones here
# Format: "LABEL:TIMEZONE"
TIMEZONES=(
    "KYV:Europe/Kiev"
    "NYC:America/New_York"
)

output=""
for tz_config in "${TIMEZONES[@]}"; do
    label="${tz_config%%:*}"
    timezone="${tz_config##*:}"
    time=$(TZ="$timezone" date +"%H:%M")

    if [ "$output" != "" ]; then
        output="$output "
    fi
    output="$output#[fg=magenta]$label #[fg=default]$time"
done

echo "$output"
