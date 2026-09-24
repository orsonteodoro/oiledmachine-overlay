#!/bin/bash

main() {
	# Commit from https://gn.googlesource.com/gn/+log
	# See also https://github.com/chromium/chromium/blob/154.0.8037.57/DEPS#L571
	GN_COMMIT=${GN_COMMIT:-"150a9d6ba0aa7f407aa4feeabc5f03ce9aa7e04b"}
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
