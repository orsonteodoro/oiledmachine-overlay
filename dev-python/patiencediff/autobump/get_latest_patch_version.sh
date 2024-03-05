#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/breezy-team/patiencediff.git" \
		| grep "refs/tags/" \
		| grep -E -e "/v?${ver//./\\.}\." \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|^v||g" -e "s|[\^]\{\}||g" \
		| sed -e "/test/d" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_patch_version ${1}
