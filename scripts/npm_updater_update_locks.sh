#!/bin/bash
# Update once a week
__NPM_UPDATER_PKG_FOLDER_PATH=$(pwd)
export NPM_UPDATER_PKG_FOLDER="${NPM_UPDATER_PKG_FOLDER:-${__NPM_UPDATER_PKG_FOLDER_PATH}}"
NPM_UPDATER_SCRIPTS_PATH=$(realpath $(dirname "${BASH_SOURCE[0]}"))

len=$(echo "${__NPM_UPDATER_PKG_FOLDER_PATH}" | tr "/" "\n" | wc -l)
CATEGORY=$(echo "${__NPM_UPDATER_PKG_FOLDER_PATH}" | cut -f $((${len} - 1)) -d "/")
PN=$(echo "${__NPM_UPDATER_PKG_FOLDER_PATH}" | cut -f ${len} -d "/")
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

npm_updater_update_npm_locks() {
	cd "${NPM_UPDATER_PKG_FOLDER}"
	local versions=(
		$(ls *ebuild \
			| tr " " "\n" \
			| grep -E -o -e "[0-9]+.[0-9]+.[0-9]+(_p[0-9]*)?(-r[0-9]+)?")
	)
	if [[ -n "${NPM_UPDATER_VERSIONS}" ]] ; then
# Do one by one because of flakey servers or node slot restrictions.
		versions=( ${NPM_UPDATER_VERSIONS} )
	fi
	export NPM_UPDATE_LOCK=1
echo "NPM_UPDATE_LOCK=${NPM_UPDATE_LOCK}"
	local pv
	for pv in ${versions[@]} ; do
		echo "Updating ${pv}"
		ebuild "${PN}-${pv}.ebuild" digest clean unpack

		local log_path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/temp/build.log")
		if grep -F "source file(s) corrupted" "${log_path}" ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv} (1)"
			exit 1
		fi

		local dest="${NPM_UPDATER_PKG_FOLDER}/files/${pv%-*}"
		mkdir -p "${dest}"
		if [[ -d "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/lockfile-image" ]] ; then
echo "DEBUG:  Case 1"
			cp -aT "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/lockfile-image" "${dest}"
		elif [[ -n "${NPM_UPDATER_PROJECT_ROOT}" ]] ; then
echo "DEBUG:  Case 2"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${NPM_UPDATER_PROJECT_ROOT}/package.json")
			cp -a "${path}" "${dest}"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${NPM_UPDATER_PROJECT_ROOT}/package-lock.json")
			if ! [[ -e "${path}" ]] ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv} (2a)"
				exit 1
			fi
			cp -a "${path}" "${dest}"
		else
echo "DEBUG:  Case 3"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/package.json")
			cp -a "${path}" "${dest}"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/package-lock.json")
			if ! [[ -e "${path}" ]] ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv} (2b)"
				exit 1
			fi
			cp -a "${path}" "${dest}"
		fi

		ebuild "${PN}-${pv}.ebuild" digest
	done
}

npm_updater_cleanup() {
echo "Called npm_updater_cleanup()"
	cd "${NPM_UPDATER_PKG_FOLDER}"
}

trap 'npm_updater_cleanup' EXIT
trap 'npm_updater_cleanup' INT

npm_updater_update_npm_locks
