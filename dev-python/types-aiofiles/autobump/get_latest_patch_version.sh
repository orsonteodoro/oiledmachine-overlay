#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	wget -q -O - "https://pypi.org/rss/project/types-aiofiles/releases.xml" \
		| grep "title" \
		| tail -n +2 \
		| cut -f 2 -d ">" \
		| cut -f 1 -d "<" \
		| sort -V \
		| grep "^${ver//./\\.}\." \
		| tail -n 1
}

get_latest_patch_version ${1}
