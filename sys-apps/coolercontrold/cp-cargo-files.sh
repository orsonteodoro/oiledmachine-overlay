#!/bin/bash
VER=${@}

main() {
	if [[ -z "${VER}" ]] ; then
		echo "Arg 1 must set to the coolercontrold version"
		exit 1
	fi

	local d_src_root="/var/tmp/portage/sys-apps/coolercontrold-${VER}/work/coolercontrol-${VER}/coolercontrold"
	local d_dest="/usr/local/oiledmachine-overlay/sys-apps/coolercontrold/files/${VER}"
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
