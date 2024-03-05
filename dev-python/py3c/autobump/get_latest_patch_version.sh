#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/encukou/py3c.git" \
		| grep "refs/tags/" \
		| sed -r -e "s|[\^]\{\}||g" \
		| grep -E -e "/v${ver//./\\.}" \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|^v||g" \
		| sed -r -e "s|a|_alpha|g" \
		| sed -r -e "s|^-([0-9]+)$|.\1|g" \
		| sed -e "s|-|.|g" \
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

get_latest_patch_version ${1}
