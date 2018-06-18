#!/bin/sh
killall polybar
PRIMARY=$(xrandr --query | grep '\bconnected\b' | grep primary | awk '{print $1}')
SECONDARY=$(xrandr --query | grep '\bconnected\b' | grep -v primary | awk '{print $1}')
xrandr --output ${PRIMARY} --auto --output ${SECONDARY} --auto --above ${PRIMARY}

MONITOR=${PRIMARY} polybar -c ~/.config/polybar/ethernet top &

if [[ ! -z ${SECONDARY} ]]; then 
    MONITOR=${SECONDARY} polybar -c ~/.config/polybar/ethernet top &
fi
