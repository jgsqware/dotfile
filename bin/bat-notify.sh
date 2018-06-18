#!/bin/bash

per=$(cat /sys/class/power_supply/BAT0/capacity)

if [ ${per} -le 10 ]; then
    DISPLAY=:0 notify-send -u critical "Battery low" "Battery level is ${per}%!"
fi
