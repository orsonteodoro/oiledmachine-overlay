#!/bin/bash
# Update once a week
__YARN_UPDATER_PKG_FOLDER_PATH=$(pwd)
export YARN_UPDATER_PKG_FOLDER="${YARN_UPDATER_PKG_FOLDER:-${__YARN_UPDATER_PKG_FOLDER_PATH}}"
YARN_UPDATER_SCRIPTS_PATH=$(realpath $(dirname "${BASH_SOURCE[0]}"))

len=$(echo "${__YARN_UPDATER_PKG_FOLDER_PATH}" | tr "/" "\n" | wc -l)
CATEGORY=$(echo "${__YARN_UPDATER_PKG_FOLDER_PATH}" | cut -f $((${len} - 1)) -d "/")
PN=$(echo "${__YARN_UPDATER_PKG_FOLDER_PATH}" | cut -f ${len} -d "/")
#echo -e "CATEGORY:\t${CATEGORY}"
#echo -e "PN:\t\t${PN}"

if [[ -z "${CATEGORY}" ]] ; then
echo "Arg 1 must be the category"
	exit 1
fi

if [[ -z "${PN}" ]] ; then
echo "Arg 2 must be the package name"
	exit 1
fi

yarn_updater_update_yarn_locks() {
	cd "${YARN_UPDATER_PKG_FOLDER}"
	local versions=(
		$(ls *ebuild \
			| tr " " "\n" \
			| grep -E -o -e "[0-9]+.[0-9]+.[0-9]+(_p[0-9]*)?(-r[0-9]+)?")
	)
	if [[ -n "${YARN_UPDATER_VERSIONS}" ]] ; then
# Do one by one because of flakey servers or node slot restrictions.
		versions=( ${YARN_UPDATER_VERSIONS} )
	fi
	export YARN_UPDATE_LOCK=1
echo "YARN_UPDATE_LOCK=${YARN_UPDATE_LOCK}"
	local pv
	for pv in ${versions[@]} ; do
		echo "Updating ${pv}"
		ebuild "${PN}-${pv}.ebuild" digest clean unpack

		local log_path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/temp/build.log")
		if grep -F "source file(s) corrupted" "${log_path}" ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv}"
			exit 1
		fi

		local dest="${YARN_UPDATER_PKG_FOLDER}/files/${pv%-*}"
		mkdir -p "${dest}"
		if [[ -d "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/lockfile-image" ]] ; then
			cp -aT "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/lockfile-image" "${dest}"
		elif [[ -n "${YARN_UPDATER_PROJECT_ROOT}" ]] ; then
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${YARN_UPDATER_PROJECT_ROOT}/package.json")
			cp -a "${path}" "${dest}"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${YARN_UPDATER_PROJECT_ROOT}/yarn.lock")
			cp -a "${path}" "${dest}"
		else
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/package.json")
			cp -a "${path}" "${dest}"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/yarn.lock")
			cp -a "${path}" "${dest}"
		fi

		ebuild "${PN}-${pv}.ebuild" digest
	done
}

yarn_updater_cleanup() {
echo "Called yarn_updater_cleanup()"
	cd "${YARN_UPDATER_PKG_FOLDER}"
}

trap 'yarn_updater_cleanup' EXIT
trap 'yarn_updater_cleanup' INT

yarn_updater_update_yarn_locks
