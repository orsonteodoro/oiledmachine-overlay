#!/bin/bash

main() {
	# Commit from https://github.com/chromium/chromium/blob/142.0.7444.59/DEPS#L506
	GN_COMMIT=${GN_COMMIT:-"81b24e01531ecf0eff12ec9359a555ec3944ec4e"}
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
