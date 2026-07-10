#!/bin/bash

main() {
	# Commit from https://gn.googlesource.com/gn/+log
	# See also https://github.com/chromium/chromium/blob/150.0.7871.114/DEPS#L557
	GN_COMMIT=${GN_COMMIT:-"3357c4f51b1a9e676378c695dd9c7e9911c35ee6"}
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
