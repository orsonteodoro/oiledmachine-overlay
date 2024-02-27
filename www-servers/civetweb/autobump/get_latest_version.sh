#!/bin/bash
get_latest_version() {
	git ls-remote --tags "https://github.com/civetweb/civetweb.git" \
		| grep "refs/tags/" \
		| sed -r -e "s|[\^]\{\}||g" \
		| grep -E -e "/v[0-9]+\.[0-9]+" \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|^v||g" \
		| sed -r -e "s|-preview|_pre|g" -e "s|-rc$|_rc|g" -e "s|-rc([0-9])$|_rc\1|g" -e "s|-alpha|_alpha|g" -e "s|-beta|_beta|g" \
		| sed -r -e "s|^-([0-9]+)$|.\1|g" \
		| sed -e "s|-|.|g" \
		| sed -e "/eclipse/d" \
		| sed -r -e "s|\.([a-z])|_\1|g" \
		| sed -r -e "s/^([0-9]+\.[0-9]+)$/\1.0_z/g" \
		| sed -r -e "s/^([0-9]+\.[0-9]+)_/\1.0_/g" \
		| sed -r -e "s|^([0-9]+\.[0-9]+\.[0-9]+)$|\1_z|g" \
		| sort -V \
		| uniq \
		| sed -r -e "s|^([0-9]+\.[0-9]+)\.0_z|\1|g" \
		| sed -r -e "s|^([0-9]+\.[0-9]+)\.0_|\1_|g" \
		| sed -e "s|_z$||g" \
		| tail -n 1
}

get_latest_version
