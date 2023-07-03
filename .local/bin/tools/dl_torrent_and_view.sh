#!/bin/sh
filepath_remote="$(echo "$1" | sed 's/\[/\\[/g; s/\\]/\\]/g')"
filename="${1##*/}"
remote=rezepte.bocken.org
notify-send "Downloading $filename"
download_path="$HOME/dls"
download_file="$download_path/$filename"
rsync -rvPu "root@$remote:$filepath_remote" "$download_file"
clear
rifle "$download_file" || ranger $download_path
