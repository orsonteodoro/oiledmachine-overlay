#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/143.0.7499.40/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"07d3c6f4dc290fae5ca6152ebcb37d6815c411ab"}
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
