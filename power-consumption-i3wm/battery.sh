#!/bin/bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus

export XDG_RUNTIME_DIR=/run/user/1000

current_state=$(
  upower -i $(upower -e | grep BAT) | grep state | awk '{print $2}'
  charging
)

if [[ "$current_state" = "charging" ]]; then
  dunstctl close-all
  exit 0
fi

current_power=$(upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}')

number=$(echo $current_power | grep -o '[[:digit:]]' | tr -d '\n')

echo $number

if [[ $number -lt 20 && $number -gt 10 ]]; then
  notify-send -t 10000 "Battery alert" "Battery at $number%"
  exit 0
elif [[ $number -lt 10 ]]; then
  notify-send --urgency=critical -t 10000 "Battery alert" "Battery at $number%. Plug in quickly"
  exit 0
fi
