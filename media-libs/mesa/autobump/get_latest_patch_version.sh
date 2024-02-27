#!/bin/bash
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://gitlab.freedesktop.org/mesa/mesa.git" \
		| grep "refs/tags/" \
		| grep -e "-${ver//./\\.}\." \
		| sed -e "s|.*/||g" \
		| sed -e "s|^v||g" \
		| grep "^mesa-" \
		| sed -r -e "s|[\^]\{\}$||g" \
		| sort -V \
		| uniq \
		| tail -n 1 \
		| sed -e "s|mesa-||"
}

get_latest_patch_version ${1}
