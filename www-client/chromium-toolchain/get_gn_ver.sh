#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/137.0.7151.68/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"ebc8f16ca7b0d36a3e532ee90896f9eb48e5423b"}
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
