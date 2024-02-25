#!/bin/bash
get_latest_version() {
	git ls-remote --tags "https://github.com/chromium/chromium.git" \
		| grep -E -e "/[0-9]+\.[0-9]+\.[0-9]+\." \
		| sed -e "s|.*/||g" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_version
