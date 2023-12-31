#!/bin/bash
get_ready_dir() {
	local row="${1}"
	mod=$(echo "${row}" | cut -f 1 -d ";")
	owner=$(echo "${row}" | cut -f 2 -d ";")
	path=$(echo "${row}" | cut -f 3 -d ";")
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
	local row="${1}"
	mod=$(echo "${row}" | cut -f 1 -d ";")
	owner=$(echo "${row}" | cut -f 2 -d ";")
	path=$(echo "${row}" | cut -f 3 -d ";")
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
