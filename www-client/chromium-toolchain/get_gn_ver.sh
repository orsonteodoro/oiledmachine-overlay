#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/147.0.7727.55/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"d8c2f07d653520568da7cace755a87dad241b72d"}
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
