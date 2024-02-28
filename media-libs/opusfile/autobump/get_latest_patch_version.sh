#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	wget -q -O - "https://ftp.osuosl.org/pub/xiph/releases/opus/" \
		| grep -o -E -e "opusfile-[0-9.]+(-src)?.tar.(gz|xz)" \
		| sort -V \
		| uniq \
		| sed -e "s|opusfile-||g" -e "s|.tar.*||g" -e "s|-src||g" \
		| grep "^${ver//./\\.}" \
		| tail -n 1
}

get_latest_patch_version ${1}
