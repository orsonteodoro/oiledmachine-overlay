#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/148.0.7778.96/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"6e8dcdebbadf4f8aa75e6a4b6e0bdf89dce1513a"}
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
