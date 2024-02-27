#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/unicode-org/icu.git" \
		| grep "refs/tags/" \
		| sed -r -e "s|[\^]\{\}||g" \
		| grep -E -e "/release-${ver//./-}(-$|-preview|-rc$|-rc[0-9]+$|$)" \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|^release-||g" \
		| sed -r -e "s|-preview|_pre|g" -e "s|-rc$|_rc|g" -e "s|-rc([0-9])$|_rc\1|g" -e "s|-alpha|_alpha|g" -e "s|-beta|_beta|g" \
		| sed -r -e "s|^-([0-9]+)$|.\1|g" \
		| sed -e "s|-|.|g" \
		| sed -e "/eclipse/d" \
		| sed -r -e "s|\.([a-z])|_\1|g" \
		| sed -r -e "s|^([0-9]+\.[0-9]+)$|\1.0_z|g" \
		| sed -r -e "s|^([0-9]+\.[0-9]+\.[0-9]+)$|\1_z|g" \
		| sort -V \
		| uniq \
		| sed -r -e "s|^([0-9]+\.[0-9]+)\.0_z$|\1|g" \
		| sed -e "s|_z$||g" \
		| tail -n 1
}

get_latest_patch_version ${1}
