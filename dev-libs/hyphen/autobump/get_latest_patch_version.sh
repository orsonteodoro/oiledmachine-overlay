#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	wget -q -O - "https://sourceforge.net/projects/hunspell/rss?path=/Hyphen" \
		| grep -o -E "hyphen-([0-9-]+\.)+tar\.gz" \
		| sed -e "s|hyphen-||g" -e "s|\.tar\.gz||g" \
		| sort -V \
		| uniq \
		| grep -E -e "${ver//./\\.}(\.|$)" \
		| tail -n 1
}

get_latest_patch_version ${1}
