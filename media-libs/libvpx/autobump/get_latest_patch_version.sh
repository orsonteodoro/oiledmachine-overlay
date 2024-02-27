#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://chromium.googlesource.com/webm/libvpx" \
		| grep "refs/tags/" \
		| sed -r -e "s|[\^]\{\}||g" \
		| grep -E -e "/v${ver//./\\.}" \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|^v||g" \
		| sed -r -e "s|-|_|g" \
		| sed -r -e "s|preview|_pre|g" \
		| sed -r -e "s|^-([0-9]+)$|.\1|g" \
		| sed -e "s|-|.|g" \
		| sed -r -e "s|\.([a-z])|_\1|g" \
		| sed -r -e "s|^([0-9]+\.[0-9]+\.[0-9]+)$|\1_z|g" \
		| sort -V \
		| uniq \
		| sed -e "s|_z$||g" \
		| tail -n 1
}

get_latest_patch_version ${1}
