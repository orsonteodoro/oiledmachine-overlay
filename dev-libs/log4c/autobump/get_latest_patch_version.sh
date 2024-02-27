#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	wget -q -O - "https://sourceforge.net/projects/log4c/rss?path=/" \
		| grep -o -E "log4c-([0-9-]+\.)+tar\.gz" \
		| sed -e "s|log4c-||g" -e "s|\.tar\.gz||g" \
		| sort -V \
		| uniq \
		| grep -e "${ver//./\\.}\." \
		| tail -n 1
}

get_latest_patch_version ${1}
