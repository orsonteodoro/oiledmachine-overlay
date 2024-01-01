#!/bin/sh
get_ready_dir() {
	local mod="${1}"
	local owner="${2}"
	local path="${3}"
	if [ ! -e "${path}" ] ; then
		mkdir -p "${path}"
		[ "${owner}" -ne "-" ] && chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	elif [ -d "${path}" ] ; then
		[ "${owner}" -ne "-" ] && chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	fi
}

get_ready_file() {
	local mod="${1}"
	local owner="${2}"
	local path="${3}"
	if [ ! -e "${path}" ] ; then
		mkdir -p $(dirname "${path}")
		touch $(basename "${path}")
		[ "${owner}" -ne "-" ] && chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	elif [ -f "${path}" ] ; then
		[ "${owner}" -ne "-" ] && chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	fi
}

is_debug() {
	if [ "${MAINTENANCE_MODE}" -eq "1" ] ; then
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
	if [ -n "${message}" ] && [ ${ret} -eq 0 ] ; then
		is_debug && echo "${message} [  OK  ]"
	elif [ -n "${message}" ] && [ ${ret} -ne 0 ] ; then
		is_debug && echo "${message} [FAILED]"
	elif [ ${ret} -eq 0 ] ; then
		is_debug && echo "[  OK  ]"
	else
		is_debug && echo "[FAILED]"
	fi
}

ewend() {
	eend
}

einfo() {
	is_debug && echo "${1}"
}

ewarn() {
	is_debug && echo "[w] ${1}"
}

eerror() {
	is_debug && echo "[e] ${1}"
	exit 1
}

einfon() {
	is_debug && echo -n "${1}"
}

ewaitfile() {
	local duration="${1}"
	shift
	L=( ${@} )
	sleep ${duration}
	local s0=$(date +"%s")
	local sf=$(( ${s0} + ${duration} ))
	while true ; do
		local c=0
		for x in ${L[@]} ; do
			[ -e "${x}" ] && c=$(( ${c} + 1 ))
		done
		if [ ${c} -eq ${#L[@]} ] ; then
			return 0
		fi
		local now=$(date +"%s")
		if [ ${now} -gt ${sf} ] ; then
			return 1
		fi
		sleep 1
	done
	return 1
}

service_started() {
	local name="${1}"
	if initctl | grep "running" | grep "${name}" 2>/dev/null 1>/dev/null ; then
		true
	else
		false
        fi
}
