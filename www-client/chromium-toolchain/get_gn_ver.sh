#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/140.0.7339.80/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"3a4f5cea73eca32e9586e8145f97b04cbd4a1aee"}
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
