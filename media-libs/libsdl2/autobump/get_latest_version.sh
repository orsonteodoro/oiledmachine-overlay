#!/bin/bash
get_latest_version() {
	git ls-remote --tags "https://github.com/libsdl-org/SDL.git" \
		| grep "refs/tags/" \
		| grep -E -e "/(release|prerelease)-[0-9]+\.[0-9]+" \
		| sed -e "s|.*/||g" \
		| sed -r -e "s/^release-//g" \
		| sed -r -e "s/^prerelease-([0-9.]+)/\1_pre/g" \
		| sed -r -e "s|^v||g" -e "s|[\^]\{\}||g" \
		| sed -e "/3.0.0_pre/d" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_version
