#!/bin/bash
VER=${@}

main() {
	if [[ -z "${VER}" ]] ; then
		echo "Arg 1 must set to the zxcvbn-rs-py version"
		exit 1
	fi

	local d_src_root="/var/tmp/portage/dev-python/zxcvbn-rs-py-${VER}/work/zxcvbn-rs-py-${VER}"
	local d_dest="/usr/local/oiledmachine-overlay/dev-python/zxcvbn-rs-py/files/${VER}"
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
