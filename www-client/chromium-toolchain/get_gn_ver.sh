#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/141.0.7390.54/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"5d0a4153b0bcc86c5a23310d5b648a587be3c56d"}
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
