#!/bin/bash

__YARN_UPDATER_PKG_FOLDER_PATH=$(pwd)

len=$(echo "${__YARN_UPDATER_PKG_FOLDER_PATH}" | tr "/" "\n" | wc -l)
CATEGORY=$(echo "${__YARN_UPDATER_PKG_FOLDER_PATH}" | cut -f $((${len} - 1)) -d "/")
PN=$(echo "${__YARN_UPDATER_PKG_FOLDER_PATH}" | cut -f ${len} -d "/")

yarn_updater_dedupe_cleanup() {
	rm uris-lst.txt
	rm extern-uris.txt
}

trap 'yarn_updater_dedupe_cleanup' EXIT
trap 'yarn_updater_dedupe_cleanup' INT

yarn_updater_main_dedupe()
{
	local versions=(
		$(ls *ebuild \
			| tr " " "\n" \
			| grep -E -o -e "[0-9]+.[0-9]+.[0-9]+(_p[0-9]*)?(-r[0-9]+)?")
	)
	if [[ -n "${YARN_UPDATER_VERSIONS}" ]] ; then
# Do one by one because of flakey servers or node slot restrictions.
		versions=( ${YARN_UPDATER_VERSIONS} )
	fi

	local pv
	for pv in ${versions[@]} ; do
		echo "Updating ${pv}"

		sed -n -e '/UPDATER_START_YARN_EXTERNAL_URIS/,/UPDATER_END_YARN_EXTERNAL_URIS/{//!p}' "${PN}-${pv}.ebuild" | sed -e "1d" -e '$d' > uris-lst.txt.t
		cat uris-lst.txt.t | LC_COLLATE=C sort | uniq > uris-lst.txt

		cat "${PN}-${pv}.ebuild" | sed -e '/UPDATER_START_YARN_EXTERNAL_URIS/,/UPDATER_END_YARN_EXTERNAL_URIS/{//!d}' > "${PN}-${pv}.ebuild.t"
		mv "${PN}-${pv}.ebuild"{.t,}

cat <<EOF > extern-uris.txt
YARN_EXTERNAL_URIS="
$(cat uris-lst.txt)
"
EOF

	        sed -i "/UPDATER_START_YARN_EXTERNAL_URIS/r extern-uris.txt" "${PN}-${pv}.ebuild"

		ebuild "${PN}-${pv}.ebuild" digest

		rm extern-uris.txt
		rm uris-lst.txt
	done
}

yarn_updater_main_dedupe
