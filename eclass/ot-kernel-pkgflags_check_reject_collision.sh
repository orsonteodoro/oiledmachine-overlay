#!/bin/bash

tempfile=$(mktemp)
main() {
	IFS=$'\n'
	for l in $(grep -E -n "\[\[.*OT_KERNEL_PKGFLAGS_REJECT[S[a-z0-9]+" ot-kernel-pkgflags.eclass) ; do
		hc=$(echo "${l}" | cut -f 4 -d '[' | cut -f 1 -d "]" | sed -e "s|^S||g")
		echo "${hc}"
	done > "${tempfile}"
	IFS=$' \t\n'
	size1=$(cat "${tempfile}" | wc -l)
	size2=$(cat "${tempfile}" | wc -l | uniq)
	if (( ${size1} == ${size2} )) ; then
		echo "No collision"
	else
		echo "Collision detected"
	fi
	echo "size1=${size1}"
	echo "size2=${size2}"
}

clean() {
	echo "Running clean()"
	rm -rf "${tempfile}"
}

trap clean EXIT

main
