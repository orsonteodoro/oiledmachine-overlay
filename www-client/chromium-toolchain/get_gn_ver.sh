#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/145.0.7632.45/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"5550ba0f4053c3cbb0bff3d60ded9d867b6fa371"}
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
