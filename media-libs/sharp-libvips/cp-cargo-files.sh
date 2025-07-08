#!/bin/bash
VER=${@}

main() {
	if [[ -z "${VER}" ]] ; then
		echo "Arg 1 must set to the gst-plugins-rs version"
		exit 1
	fi

	local d_src_root="/var/tmp/portage/media-libs/sharp-libvips-${VER}/work"
	local d_dest="/usr/local/oiledmachine-overlay/media-libs/sharp-libvips/files/${VER}"
echo "d_src_root:  ${d_src_root}"
echo "d_dest:  ${d_dest}"
	pushd "${d_src_root}"
		for x in $(find . -name "Cargo.*") ; do
			local d=$(dirname "${x}")
			mkdir -p "${d_dest}/${d}"
			cp -v -a "${x}" "${d_dest}/${d}"
		done
	popd
}

main
