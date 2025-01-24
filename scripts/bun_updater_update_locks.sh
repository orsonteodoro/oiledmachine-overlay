#!/bin/bash
# Update once a week
__BUN_UPDATER_PKG_FOLDER_PATH=$(pwd)
export BUN_UPDATER_PKG_FOLDER="${BUN_UPDATER_PKG_FOLDER:-${__BUN_UPDATER_PKG_FOLDER_PATH}}"
BUN_UPDATER_SCRIPTS_PATH=$(realpath $(dirname "${BASH_SOURCE[0]}"))

len=$(echo "${__BUN_UPDATER_PKG_FOLDER_PATH}" | tr "/" "\n" | wc -l)
CATEGORY=$(echo "${__BUN_UPDATER_PKG_FOLDER_PATH}" | cut -f $((${len} - 1)) -d "/")
PN=$(echo "${__BUN_UPDATER_PKG_FOLDER_PATH}" | cut -f ${len} -d "/")
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

bun_updater_update_bun_locks() {
	cd "${BUN_UPDATER_PKG_FOLDER}"
	local versions=(
		$(ls *ebuild \
			| tr " " "\n" \
			| grep -E -o -e "[0-9]+.[0-9]+.[0-9]+(_p[0-9]*)?(-r[0-9]+)?")
	)
	if [[ -n "${BUN_UPDATER_VERSIONS}" ]] ; then
# Do one by one because of flakey servers or node slot restrictions.
		versions=( ${BUN_UPDATER_VERSIONS} )
	fi
	export BUN_UPDATE_LOCK=1
echo "BUN_UPDATE_LOCK=${BUN_UPDATE_LOCK}"
	local pv
	for pv in ${versions[@]} ; do
		echo "Updating ${pv}"
		ebuild "${PN}-${pv}.ebuild" digest clean unpack

		local log_path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/temp/build.log")
		if grep -F "source file(s) corrupted" "${log_path}" ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv} (1)"
			exit 1
		fi

		local dest="${BUN_UPDATER_PKG_FOLDER}/files/${pv%-*}"
		mkdir -p "${dest}"
		if [[ -d "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/lockfile-image" ]] ; then
echo "DEBUG:  Case 1"
			cp -aT "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/lockfile-image" "${dest}"
		elif [[ -n "${BUN_UPDATER_PROJECT_ROOT}" ]] ; then
echo "DEBUG:  Case 2"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${BUN_UPDATER_PROJECT_ROOT}/package.json")
			cp -a "${path}" "${dest}"
			local path
			if [[ -e "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${BUN_UPDATER_PROJECT_ROOT}/bun.lock" ]] ; then
				path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${BUN_UPDATER_PROJECT_ROOT}/bun.lock")
			elif [[ -e "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${BUN_UPDATER_PROJECT_ROOT}/bun.lockb" ]] ; then
				path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${BUN_UPDATER_PROJECT_ROOT}/bun.lockb")
			fi
			if ! [[ -e "${path}" ]] ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv} (2a)"
				exit 1
			fi
			cp -a "${path}" "${dest}"
		else
echo "DEBUG:  Case 3"
			local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/package.json")
			cp -a "${path}" "${dest}"
			local path
			if [[ -e "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/bun.lock" ]] ; then
				path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/bun.lock")
			elif [[ -e "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/bun.lockb" ]] ; then
				path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/bun.lockb")
			fi
			if ! [[ -e "${path}" ]] ; then
echo "Fail lockfile for =${CATEGORY}/${PN}-${pv} (2b)"
				exit 1
			fi
			cp -a "${path}" "${dest}"
		fi

		ebuild "${PN}-${pv}.ebuild" digest
	done
}

bun_updater_cleanup() {
echo "Called bun_updater_cleanup()"
	cd "${BUN_UPDATER_PKG_FOLDER}"
}

trap 'bun_updater_cleanup' EXIT
trap 'bun_updater_cleanup' INT

bun_updater_update_bun_locks
