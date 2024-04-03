#!/bin/bash
get_latest_version() {
	git ls-remote --tags "https://github.com/RodZill4/material-maker.git" \
		| grep "refs/tags/" \
		| grep -E -e "/v?([0-9]+\.)" \
		| sed -e "s|/v|/|" \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|[\^]\{\}||g" \
		| sed -r -e "s|(\.[0-9]+)$|\1_|g" \
		| sed -r -e "s|p|_p|g" \
		| sed -r -e "s|\.([0-9]+)$|\1_|g" \
		| sort -V \
		| uniq \
		| sed -r -e "s|_$||g" \
		| tail -n 1
}

get_latest_version
