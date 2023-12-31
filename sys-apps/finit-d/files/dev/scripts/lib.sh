#!/bin/bash
get_ready_dir() {
	local mod="${1}"
	local owner="${2}"
	local path="${3}"
	if [[ ! -e "${path}" ]] ; then
		mkdir -p "${path}"
		chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	elif [[ -d "${path}" ]] ; then
		chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	fi
}

get_ready_file() {
	local mod="${1}"
	local owner="${2}"
	local path="${3}"
	if [[ ! -e "${path}" ]] ; then
		mkdir -p $(dirname "${path}")
		touch $(basename "${path}")
		chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	elif [[ -f "${path}" ]] ; then
		chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	fi
}

is_debug() {
	if [[ "${MAINTENANCE_MODE}" == "1" ]] ; then
		return 0
	else
		return 1
	fi
}

ebegin() {
	is_debug && echo "${1}"
}

eend() {
	local ret="${1}"
	local message="${2}"
	if [[ -n "${message}" ]] ; then
		is_debug && echo "${message}"
	fi
	if (( ${ret} == 0 )) ; then
		true
	else
		false
	fi
}

eerror() {
	is_debug && echo "${1}"
	exit 1
}
