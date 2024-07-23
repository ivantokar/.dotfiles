#!/bin/zsh

weather_data=$(curl -s "http://api.openweathermap.org/data/2.5/weather?id=710719&appid=a19f36b41fb4fec30afa72df72d89bde&units=metric")
temperature=$(echo $weather_data | jq '.main.temp' | xargs printf "%.0f")
weather_icon=$(echo $weather_data | jq -r '.weather[0].icon')

# Map OpenWeatherMap icon codes to Unicode characters
case "$weather_icon" in
    '01d' | '01n') icon="#[fg=yellow]#[fg=default]" ;;  # Clear sky
    '02d' | '02n') icon="" ;;  # Few clouds
    '03d' | '03n') icon="" ;;  # Scattered clouds
    '04d' | '04n') icon="" ;;  # Broken clouds
    '09d' | '09n') icon="#[fg=blue]#[fg=default]" ;;  # Shower rain
    '10d' | '10n') icon="#[fg=blue]#[fg=default]" ;;  # Rain
    '11d' | '11n') icon="#[fg=blue]#[fg=default]" ;;  # Thunderstorm
    '13d' | '13n') icon="#[fg=blue]#[fg=default]" ;;  # Snow
    '50d' | '50n') icon="" ;;  # Mist
  *) icon="?" ;;               # Default icon for unknown codesc
esac

echo "${icon} ${temperature}°C" 
