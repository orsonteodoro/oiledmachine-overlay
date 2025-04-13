#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/134.0.6998.88/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"4a8016dc391553fa1644c0740cc04eaac844121e"}
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
