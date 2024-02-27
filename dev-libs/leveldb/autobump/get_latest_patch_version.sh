#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/google/leveldb.git" \
		| grep "refs/tags/" \
		| sed -r -e "s|^v||g" -e "s|[\^]\{\}||g" \
		| grep -e "/${ver//./\\.}$" \
		| sed -e "s|.*/||g" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_patch_version ${1}
