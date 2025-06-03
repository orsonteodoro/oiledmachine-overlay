#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/137.0.7151.68/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"85cc21e94af590a267c1c7a47020d9b420f8a033"}
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
