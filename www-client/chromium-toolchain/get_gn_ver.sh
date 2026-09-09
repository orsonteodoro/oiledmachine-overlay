#!/bin/bash

main() {
	# Commit from https://gn.googlesource.com/gn/+log
	# See also https://github.com/chromium/chromium/blob/153.0.8010.36/DEPS#L567
	GN_COMMIT=${GN_COMMIT:-"e8a8e0932a5e42a99e5896aa58e3b8290f4e5b8c"}
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
