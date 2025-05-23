#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/136.0.7103.59/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"6e8e0d6d4a151ab2ed9b4a35366e630c55888444"}
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
