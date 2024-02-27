#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/python/typing_extensions.git" \
		| grep "refs/tags/" \
		| grep -e "/${ver}" \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|[\^]\{\}||g" \
		| sed -r -e "s|([0-9])rc|\1_rc|g" \
		| sed -r -e "s|(\.[0-9]+)$|\1_z|g" \
		| sort -V \
		| uniq \
		| sed -r -e "s|_z$||g" \
		| tail -n 1
}

get_latest_patch_version ${1}
