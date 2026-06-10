#!/bin/bash
VER=${@}

main() {
	if [[ -z "${VER}" ]] ; then
		echo "Arg 1 must set to the ormsgpack version"
		exit 1
	fi

	local d_src_root="/var/tmp/portage/dev-python/ormsgpack-${VER}/work/ormsgpack-${VER}"
	local d_dest="/usr/local/oiledmachine-overlay/dev-python/ormsgpack/files/${VER}"
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
