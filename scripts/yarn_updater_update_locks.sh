#!/bin/bash
# Update once a week
_PKG_FOLDER=$(pwd)
export PKG_FOLDER="${PKG_FOLDER:-${_PKG_FOLDER}}"
YARN_UPDATER_SCRIPTS_PATH=$(realpath $(dirname "${BASH_SOURCE[0]}"))
MODE="uri-list-only"
CATEGORY="${1}"
PN="${2}"

if [[ -z "${CATEGORY}" ]] ; then
echo "Arg 1 must be the category"
	exit 1
fi

if [[ -z "${PN}" ]] ; then
echo "Arg 2 must be the package name"
	exit 1
fi

MY_PN="${PN}"
my_dir=$(dirname "$0")
yarn_updater_update_yarn_locks() {
	cd "${PKG_FOLDER}"
	local versions=(
		$(ls *ebuild \
			| tr " " "\n" \
			| grep -E -o -e "[0-9]+.[0-9]+.[0-9]+(-r[0-9]+)?")
	)
# Do one by one because of flakey servers.
#	versions=(4.1.6)
	export UPDATE_YARN_LOCK=1
	local pv
	for pv in ${versions[@]} ; do
		echo "Updating ${pv}"
		cat "${PN}-${pv}.ebuild" | sed -e '/UPDATER_START_YARN_EXTERNAL_URIS/,/UPDATER_END_YARN_EXTERNAL_URIS/{//!d}' > "${PN}-${pv}.ebuild.t"
		mv "${PN}-${pv}.ebuild"{.t,}
cat <<EOF > extern-uris.txt
YARN_EXTERNAL_URIS="
"
EOF
		local block
		block=$(cat extern-uris.txt)
		sed -i "/UPDATER_START_YARN_EXTERNAL_URIS/r extern-uris.txt" "${PN}-${pv}.ebuild"
		if [[ "${MODE}" == "uri-list-only" ]] ; then
			ebuild "${PN}-${pv}.ebuild" digest
			grep "resolved" "${PKG_FOLDER}/files/${pv%-*}/yarn.lock" \
				| cut -f 2 -d '"' \
				> yarn-uris.txt
		elif [[ "${MODE}" == "full" ]] ; then
			ebuild "${PN}-${pv}.ebuild" digest clean unpack
			cp -a "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${MY_PN}-${pv%-*}/yarn.lock" "${my_dir}/files/${pv%-*}"
			grep "resolved" "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${MY_PN}-${pv%-*}/yarn.lock" \
				| cut -f 2 -d '"' \
				> yarn-uris.txt
		fi
		"${YARN_UPDATER_SCRIPTS_PATH}/yarn_updater_transform_uris.sh" > transformed-uris.txt
		cat "${PN}-${pv}.ebuild" | sed -e '/UPDATER_START_YARN_EXTERNAL_URIS/,/UPDATER_END_YARN_EXTERNAL_URIS/{//!d}' > "${PN}-${pv}.ebuild.t"
		mv "${PN}-${pv}.ebuild"{.t,}
cat <<EOF > extern-uris.txt
YARN_EXTERNAL_URIS="
$(cat transformed-uris.txt)
"
EOF
		block=$(cat extern-uris.txt)
		sed -i "/UPDATER_START_YARN_EXTERNAL_URIS/r extern-uris.txt" "${PN}-${pv}.ebuild"
		ebuild "${PN}-${pv}.ebuild" digest
	done
}

yarn_updater_cleanup() {
echo "Called yarn_updater_cleanup()"
	cd "${PKG_FOLDER}"
	rm extern-uris.txt
	rm transformed-uris.txt
	rm yarn-uris.txt
}

trap 'yarn_updater_cleanup' EXIT
trap 'yarn_updater_cleanup' INT

yarn_updater_update_yarn_locks
