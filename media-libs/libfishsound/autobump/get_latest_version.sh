#!/bin/bash
get_latest_version() {
	wget -q -O - "https://ftp.osuosl.org/pub/xiph/releases/libfishsound/" \
		| grep -o -E -e "libfishsound-[0-9.]+(-src)?.tar.(gz|xz)" \
		| sort -V \
		| uniq \
		| sed -e "s|libfishsound-||g" -e "s|.tar.*||g" -e "s|-src||g" \
		| tail -n 1
}

get_latest_version
