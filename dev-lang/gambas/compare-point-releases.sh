#/bin/bash
#
# Checks only dependency lists and options
#
# Usage:
# ./compare-point-releases.sh 2.38.2 2.38.3

PV1="${1}"
PV2="${2}"
main() {
	S_OLD="/var/tmp/portage/dev-lang/gambas-${PV1}/work/gambas-${PV1}/"
	S_NEW="/var/tmp/portage/dev-lang/gambas-${PV2}/work/gambas-${PV2}/"
	local P=(
		$(grep -l "State=" $(find "${S_NEW}" -name "*.component") | cut -f 9- -d "/")
		$(find "${S_NEW}" -name "configure.ac" -o -name ".gitlab-ci.yml" | cut -f 9- -d "/")
	)
	for p in ${P[@]} ; do
		echo
		echo "Comparing ${p}:"
		C="${p}" D1="${S_OLD}" ; D2="${S_NEW}" ; diff  -urp "${D1}/${C}" "${D2}/${C}" # For individual comparisons
		echo
	done
}

main
