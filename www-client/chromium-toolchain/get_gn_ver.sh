#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/149.0.7827.102/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"1740f5c25bcac5a650ee3d1c1ec22bfa25fcd756"}
	echo "GN_COMMIT: ${GN_COMMIT}"

	if ! [[ -e "gn" ]] ; then
		git clone https://gn.googlesource.com/gn
	else
		cd gn
		git pull
	fi
	cd "gn"
	git checkout ${GN_COMMIT}
	v=$(git describe HEAD --abbrev=12 | cut -f 3 -d "-")
	python -c "print(${v}/10000)" or echo "0.${v}"
}

main
