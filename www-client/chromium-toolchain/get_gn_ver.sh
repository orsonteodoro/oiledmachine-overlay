#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/144.0.7559.59/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"6e0b557db44b3c164094e57687d20ba036a80667"}
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
