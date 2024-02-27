#!/bin/bash
get_latest_version() {
	wget -q -O - "https://sourceforge.net/projects/log4c/rss?path=/" \
		| grep -o -E "log4c-([0-9-]+\.)+tar\.gz" \
		| sed -e "s|log4c-||g" -e "s|\.tar\.gz||g" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_version
