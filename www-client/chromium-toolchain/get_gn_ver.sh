#!/bin/bash

main() {
	# Commit from https://gn.googlesource.com/gn/+log
	# See also https://github.com/chromium/chromium/blob/155.0.8059.39/DEPS#L571
	GN_COMMIT=${GN_COMMIT:-"cfcd774b98f3433e18b722f9a7ff06119825b8eb"}
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
