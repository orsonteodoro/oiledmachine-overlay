#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/google-deepmind/dm_control.git" \
		| grep "refs/tags/" \
		| grep -e "/${ver//./\\.}\." \
		| sed -e "s|.*/||g" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_patch_version ${1}
