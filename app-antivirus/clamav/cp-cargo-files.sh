#!/bin/bash
VER=${@}

main() {
	if [[ -z "${VER}" ]] ; then
		echo "Arg 1 must set to the clamav version"
		exit 1
	fi

	local d_src_root="/var/tmp/portage/app-antivirus/clamav-${VER}/work/clamav-clamav-${VER}"
	local d_dest="/usr/local/oiledmachine-overlay/app-antivirus/clamav/files/${VER}"
	pushd "${d_src_root}"
		for x in $(find . -name "Cargo.*") ; do
			local d=$(dirname "${x}")
			mkdir -p "${d_dest}/${d}"
			cp -v -a "${x}" "${d_dest}/${d}"
		done
	popd
}

main
