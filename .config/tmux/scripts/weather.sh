#!/bin/zsh

# Load environment variables from .zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# ===== CONFIGURATION =====
# Temperature units: "metric" (Celsius) or "imperial" (Fahrenheit)
UNITS="metric"

# City ID (find yours at: https://openweathermap.org/find)
# Current: 710719 (Kharkiv, UA)
CITY_ID="710719"

# API Key - IMPORTANT: Set this in your ~/.zshrc.local to keep it private:
# export OPENWEATHER_API_KEY="your_api_key_here"
# Get your API key at: https://openweathermap.org/api
API_KEY="${OPENWEATHER_API_KEY}"

# Show feels-like temperature instead of actual
SHOW_FEELS_LIKE=false

# ===== END CONFIGURATION =====

# Check if API key is set
if [ -z "$API_KEY" ]; then
    echo "#[fg=yellow]#[fg=default] Set OPENWEATHER_API_KEY"
    exit 0
fi

# Fetch weather data
weather_data=$(curl -s "http://api.openweathermap.org/data/2.5/weather?id=${CITY_ID}&appid=${API_KEY}&units=${UNITS}")

# Check if curl was successful
if [ $? -ne 0 ] || [ -z "$weather_data" ]; then
    echo "#[fg=yellow]#[fg=default] Weather unavailable"
    exit 0
fi

# Parse temperature
if [ "$SHOW_FEELS_LIKE" = true ]; then
    temperature=$(echo $weather_data | jq '.main.feels_like' | xargs printf "%.0f")
else
    temperature=$(echo $weather_data | jq '.main.temp' | xargs printf "%.0f")
fi

# Get weather icon code
weather_icon=$(echo $weather_data | jq -r '.weather[0].icon')

# Map OpenWeatherMap icon codes to Nerd Font Material Design icons (nf-md-weather-*)
case "$weather_icon" in
    '01d') icon="#[fg=yellow]󰖙#[fg=default]" ;;  # nf-md-weather_sunny - Clear sky day
    '01n') icon="#[fg=blue]󰖔#[fg=default]" ;;  # nf-md-weather_night - Clear sky night
    '02d') icon="#[fg=yellow]󰖕#[fg=default]" ;;  # nf-md-weather_partly_cloudy - Few clouds day
    '02n') icon="#[fg=blue]󰼱#[fg=default]" ;;  # nf-md-weather_night_partly_cloudy - Few clouds night
    '03d' | '03n') icon="󰖐" ;;  # nf-md-weather_cloudy - Scattered clouds
    '04d' | '04n') icon="󰖐" ;;  # nf-md-weather_cloudy - Broken clouds
    '09d' | '09n') icon="#[fg=blue]󰖗#[fg=default]" ;;  # nf-md-weather_pouring - Shower rain
    '10d' | '10n') icon="#[fg=blue]󰖖#[fg=default]" ;;  # nf-md-weather_rainy - Rain
    '11d' | '11n') icon="#[fg=yellow]󰙾#[fg=default]" ;;  # nf-md-weather_lightning - Thunderstorm
    '13d' | '13n') icon="#[fg=cyan]󰖘#[fg=default]" ;;  # nf-md-weather_snowy - Snow
    '50d' | '50n') icon="󰖑" ;;  # nf-md-weather_fog - Mist
    *) icon="󰔏" ;;  # nf-md-thermometer - Default thermometer icon
esac

# Determine temperature unit symbol
if [ "$UNITS" = "imperial" ]; then
    unit_symbol="°F"
else
    unit_symbol="°C"
fi

echo "${icon} ${temperature}${unit_symbol}"
