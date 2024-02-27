#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/KhronosGroup/OpenXR-SDK-Source.git" \
		| grep "/release-${ver//./\\.}\." \
		| sed -e "s|.*/||g" \
		| sed -r -e "s|[\^]\{\}||g" -e "s|release-||g" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_patch_version ${1}
