#!/bin/bash
# Update once a week
__PNPM_UPDATER_PKG_FOLDER_PATH=$(pwd)
export PNPM_UPDATER_PKG_FOLDER="${PNPM_UPDATER_PKG_FOLDER:-${__PNPM_UPDATER_PKG_FOLDER_PATH}}"
PNPM_UPDATER_SCRIPTS_PATH=$(realpath $(dirname "${BASH_SOURCE[0]}"))

len=$(echo "${__PNPM_UPDATER_PKG_FOLDER_PATH}" | tr "/" "\n" | wc -l)
CATEGORY=$(echo "${__PNPM_UPDATER_PKG_FOLDER_PATH}" | cut -f $((${len} - 1)) -d "/")
PN=$(echo "${__PNPM_UPDATER_PKG_FOLDER_PATH}" | cut -f ${len} -d "/")
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

pnpm_updater_update_pnpm_locks() {
	cd "${PNPM_UPDATER_PKG_FOLDER}"
	local versions=(
		$(ls *ebuild \
			| tr " " "\n" \
			| grep -E -o -e "[0-9]+.[0-9]+.[0-9]+(_p[0-9]*)?(-r[0-9]+)?")
	)
	if [[ -n "${PNPM_UPDATER_VERSIONS}" ]] ; then
# Do one by one because of flakey servers or node slot restrictions.
		versions=( ${PNPM_UPDATER_VERSIONS} )
	fi
	export PNPM_UPDATE_LOCK=1
echo "PNPM_UPDATE_LOCK=${PNPM_UPDATE_LOCK}"
	local pv
	for pv in ${versions[@]} ; do
		echo "Updating ${pv}"
		ebuild "${PN}-${pv}.ebuild" digest clean unpack

		local log_path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/temp/build.log")
		if grep -F "source file(s) corrupted" "${log_path}" ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv} (1)"
			exit 1
		fi

		local dest="${PNPM_UPDATER_PKG_FOLDER}/files/${pv%-*}"
		mkdir -p "${dest}"
		if [[ -d "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/lockfile-image" ]] ; then
echo "DEBUG:  Case 1"
			cp -aT "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/lockfile-image" "${dest}"
		elif [[ -n "${PNPM_UPDATER_PROJECT_ROOT}" ]] ; then
echo "DEBUG:  Case 2"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${PNPM_UPDATER_PROJECT_ROOT}/package.json")
			cp -a "${path}" "${dest}"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${PNPM_UPDATER_PROJECT_ROOT}/pnpm-lock.yaml")
			if ! [[ -e "${path}" ]] ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv} (2a)"
				exit 1
			fi
			cp -a "${path}" "${dest}"
		else
echo "DEBUG:  Case 3"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/package.json")
			cp -a "${path}" "${dest}"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/pnpm-lock.yaml")
			if ! [[ -e "${path}" ]] ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv} (2b)"
				exit 1
			fi
			cp -a "${path}" "${dest}"
		fi

		ebuild "${PN}-${pv}.ebuild" digest
	done
}

pnpm_updater_cleanup() {
echo "Called pnpm_updater_cleanup()"
	cd "${PNPM_UPDATER_PKG_FOLDER}"
}

trap 'pnpm_updater_cleanup' EXIT
trap 'pnpm_updater_cleanup' INT

pnpm_updater_update_pnpm_locks
