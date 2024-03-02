#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/embree/embree.git" \
		| grep "refs/tags/" \
		| grep -E -e "/v${ver//./\\.}\." \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|^v||g" -e "s|[\^]\{\}||g" \
		| sed -e "s|alpha\.|alpha|g" \
		| sed -e "s|beta\.|beta|g" \
		| sed -e "s|-|_|g" \
		| sed -e "/ploc/d" -e "/knc/d" \
		| sed -r -e "s|^([0-9]+\.[0-9]+\.[0-9]+)$|\1_z|g" \
		| sort -V \
		| uniq \
		| sed -r -e "s|_z||g" \
		| tail -n 1
}

get_latest_patch_version ${1}
