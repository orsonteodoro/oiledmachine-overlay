#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/146.0.7680.71/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"304bbef6c7e9a86630c12986b99c8654eb7fe648"}
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
