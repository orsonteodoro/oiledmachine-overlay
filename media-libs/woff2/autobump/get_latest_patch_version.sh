#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/google/woff2.git" \
		| grep "refs/tags/" \
		| grep -e "/v${ver//./\\.}\." \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|^v||g" -e "s|[\^]\{\}||g" \
		| sed -r -e "s|^([0-9]+\.[0-9]+\.[0-9]+)$|\1_z|g" \
		| sed -e "s|rc|_rc|g" \
		| sort -V \
		| uniq \
		| sed -e "s|_z$||g" \
		| tail -n 1
}

get_latest_patch_version ${1}
