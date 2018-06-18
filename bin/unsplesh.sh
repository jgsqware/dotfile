#!/bin/bash

mkdir -p ~/.config/unsplesh/saved
DL_PATH=~/.config/unsplesh/

if [[ $1 == "save" ]]; then
    cp ${DL_PATH}/bg.jpg ${DL_PATH}/saved/$(echo $RANDOM$RANDOM).jpg
fi

DOWNLOAD_URL=$(curl https://api.unsplash.com/photos/random\?client_id\=${1}\&w\=2560\&h\=1440\&query\='landscape,tech,nature,wallpaper,abstract,city,background,food' | jq -r ".urls.custom")
wget -O ~/.config/unsplesh/bg.jpg ${DOWNLOAD_URL}
feh --bg-fill ~/.config/unsplesh/bg.jpg
