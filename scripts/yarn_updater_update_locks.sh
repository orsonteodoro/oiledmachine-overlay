#!/bin/bash
# Update once a week
__YARN_UPDATER_PKG_FOLDER_PATH=$(pwd)
export YARN_UPDATER_PKG_FOLDER="${YARN_UPDATER_PKG_FOLDER:-${__YARN_UPDATER_PKG_FOLDER_PATH}}"
YARN_UPDATER_SCRIPTS_PATH=$(realpath $(dirname "${BASH_SOURCE[0]}"))
YARN_UPDATER_MODE="${YARN_UPDATER_MODE:-full}"

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
		cat "${PN}-${pv}.ebuild" | sed -e '/UPDATER_START_YARN_EXTERNAL_URIS/,/UPDATER_END_YARN_EXTERNAL_URIS/{//!d}' > "${PN}-${pv}.ebuild.t"
		mv "${PN}-${pv}.ebuild"{.t,}
cat <<EOF > extern-uris.txt
YARN_EXTERNAL_URIS="
"
EOF
		local block
		block=$(cat extern-uris.txt)
		sed -i "/UPDATER_START_YARN_EXTERNAL_URIS/r extern-uris.txt" "${PN}-${pv}.ebuild"
		if [[ "${YARN_UPDATER_MODE}" == "uri-list-only" ]] ; then
			ebuild "${PN}-${pv}.ebuild" digest

			local dest="${YARN_UPDATER_PKG_FOLDER}/files/${pv%-*}"
			local nlocks=$(grep -r -l -e "resolved" "${dest}" | wc -l)
			if (( ${nlocks} > 1 )) ; then
echo "Multilock package detected"
				grep -r -e "resolved" "${dest}" \
					| cut -f 2 -d '"' \
					> yarn-uris.txt
			else
				grep "resolved" "${YARN_UPDATER_PKG_FOLDER}/files/${pv}/yarn.lock" \
					| cut -f 2 -d '"' \
					> yarn-uris.txt
			fi
		elif [[ "${YARN_UPDATER_MODE}" == "full" ]] ; then
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
				grep -r -e "resolved" "${dest}" \
					| cut -f 2 -d '"' \
					> yarn-uris.txt
			elif [[ -n "${YARN_UPDATER_PROJECT_ROOT}" ]] ; then
				local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${YARN_UPDATER_PROJECT_ROOT}/package.json")
				cp -a "${path}" "${dest}"
				local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/${YARN_UPDATER_PROJECT_ROOT}/yarn.lock")
				cp -a "${path}" "${dest}"
				grep "resolved" "${path}" \
					| cut -f 2 -d '"' \
					> yarn-uris.txt
			else
				local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/package.json")
				cp -a "${path}" "${dest}"
				local path=$(ls "/var/tmp/portage/${CATEGORY}/${PN}-${pv}/work/"*"/yarn.lock")
				cp -a "${path}" "${dest}"
				grep "resolved" "${path}" \
					| cut -f 2 -d '"' \
					> yarn-uris.txt
			fi
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

		#sed -i "/UPDATER_START_YARN_EXTERNAL_URIS/r extern-uris.txt" "${PN}-${pv}.ebuild"

		ebuild "${PN}-${pv}.ebuild" digest
	done
}

yarn_updater_cleanup() {
echo "Called yarn_updater_cleanup()"
	cd "${YARN_UPDATER_PKG_FOLDER}"
	rm extern-uris.txt
	rm transformed-uris.txt
	rm yarn-uris.txt
}

trap 'yarn_updater_cleanup' EXIT
trap 'yarn_updater_cleanup' INT

yarn_updater_update_yarn_locks
