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

# Assumes eend called to add either [OK] or [FAILED]
ebegin() {
	is_debug && echo -n "${1}"
}

eend() {
	local ret="${1}"
	local message="${2}"
	if [[ -n "${message}" ]] && (( ${ret} == 0 )) ; then
		is_debug && echo "${message} [OK]"
	elif [[ -n "${message}" ]] && (( ${ret} != 0 )) ; then
		is_debug && echo "${message} [FAIL]"
	elif (( ${ret} == 0 )) ; then
		is_debug && echo "[  OK  ]"
	else
		is_debug && echo "[FAILED]"
	fi
}

eerror() {
	is_debug && echo "${1}"
	exit 1
}
