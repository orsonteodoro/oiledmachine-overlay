#!/bin/sh
winid="$1"
url="$2"
title="$3"

# Log url to history.
#echo "page_load_committed:" "$(date +'%Y-%m-%d %H:%M:%S')" "$url" "$title" >> $HOME/historytest

# Adblock script.
python3 /etc/surf/scripts/adblock/adblock.py $winid $url
