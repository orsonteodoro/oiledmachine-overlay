#!/bin/bash
get_latest_version() {
	git ls-remote --tags "https://github.com/randy408/libspng.git" \
		| grep "refs/tags/" \
		| sed -r -e "s|[\^]\{\}||g" \
		| grep -E -e "/v[0-9]+\.[0-9]+" \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|^v||g" \
		| sed -r -e "s|-rc$|_rc|g" -e "s|-rc([0-9])$|_rc\1|g" \
		| sed -r -e "s|^-([0-9]+)$|.\1|g" \
		| sed -e "s|-|.|g" \
		| sed -r -e "s|\.([a-z])|_\1|g" \
		| sed -r -e "s|^([0-9]+\.[0-9]+\.[0-9]+)$|\1_z|g" \
		| sort -V \
		| uniq \
		| sed -e "s|_z$||g" \
		| tail -n 1
}

get_latest_version
