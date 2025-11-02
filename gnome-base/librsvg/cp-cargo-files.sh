#!/bin/bash
VER=${@}

CATEGORY="gnome-base"
PN="librsvg"
OVERLAY_PATH=${OVERLAY_PATH:-"/usr/local/oiledmachine-overlay"}

main() {
	if [[ -z "${VER}" ]] ; then
		echo "Arg 1 must set to the clamav version"
		exit 1
	fi

	local d_src_root="/var/tmp/portage/${CATEGORY}/${PN}-${VER}/work/${PN}-${VER}"
	local d_dest="${OVERLAY_PATH}/${CATEGORY}/${PN}/files/${VER}"
	pushd "${d_src_root}"
		for x in $(find . -name "Cargo.*") ; do
			local d=$(dirname "${x}")
			mkdir -p "${d_dest}/${d}"
			cp -v -a "${x}" "${d_dest}/${d}"
		done
	popd
}

main
