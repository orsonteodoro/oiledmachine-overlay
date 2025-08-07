#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/139.0.7258.66/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"97b68a0bb62b7528bc3491c7949d6804223c2b82"}
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
