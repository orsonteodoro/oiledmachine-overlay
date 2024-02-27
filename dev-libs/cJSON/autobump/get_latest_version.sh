#!/bin/bash
get_latest_version() {
	git ls-remote --tags "https://github.com/DaveGamble/cJSON.git" \
		| grep "refs/tags/" \
		| grep -E -e "/v[0-9]+\.[0-9]+" \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|^v||g" -e "s|[\^]\{\}||g" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_version
