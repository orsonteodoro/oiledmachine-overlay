#!/bin/bash
get_latest_version() {
	wget -q -O - "https://ftp.osuosl.org/pub/xiph/releases/opus/" \
		| grep -o -E -e "opusfile-[0-9.]+(-src)?.tar.(gz|xz)" \
		| sort -V \
		| uniq \
		| sed -e "s|opusfile-||g" -e "s|.tar.*||g" -e "s|-src||g" \
		| tail -n 1
}

get_latest_version
