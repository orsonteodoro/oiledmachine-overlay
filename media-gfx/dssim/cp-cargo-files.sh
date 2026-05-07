#!/bin/bash
VER=${@}

main() {
	if [[ -z "${VER}" ]] ; then
		echo "Arg 1 must set to the dssim version"
		exit 1
	fi

	local d_src_root="/var/tmp/portage/dev-python/dssim-${VER}/work/dssim-${VER}"
	local d_dest="/usr/local/oiledmachine-overlay/dev-python/dssim/files/${VER}"
	IFS=$'\n'
	pushd "${d_src_root}"
		for x in $(find . -name "Cargo.*") ; do
			local d=$(dirname "${x}")
			mkdir -p "${d_dest}/${d}"
			cp -v -a "${x}" "${d_dest}/${d}"
		done
	popd
	IFS=$' \n\r\t'
}

main
