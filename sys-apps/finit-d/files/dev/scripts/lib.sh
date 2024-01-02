#!/bin/sh
checkpath() {
	local type="${1}"
	local owner="${2}"
	local mode="${3}"
	local path="${4}"
	path=$(realpath "${path}")

	if [ "${type}" = "d" ] && [ ! -d "${path}" ] ; then
		if [ "${path}" = "/" ] ; then
			exit 1
		fi
		rm -rf "${path}"
		mkdir -p "${path}"
	fi

	if [ "${type}" = "f" ] && [ ! -f "${path}" ] ; then
		if [ "${path}" = "/" ] ; then
			exit 1
		fi
		rm -rf "${path}"
		mkdir -p $(dirname "${path}")
		touch "${path}"
	fi

	if [ "${owner}" != "-" ] ; then
		chown "${owner}" "${path}"
	fi
	if [ "${mode}" != "-" ] ; then
		chmod "${mode}" "${path}"
	elif [ "${type}" = "d" ] ; then
		chmod "0775" "${path}"
	elif [ "${type}" = "f" ] ; then
		chmod "0644" "${path}"
	fi
}

is_debug() {
	if [ "${MAINTENANCE_MODE}" = "1" ] ; then
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
	local ret=${1}
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
	local duration=${1}
	shift
	L=( ${@} )
	sleep ${duration}
	local s0=$(date +"%s")
	local sf=$(( ${s0} + ${duration} ))
	while true ; do
		local c=0
		for x in ${L[@]} ; do
			if [ -e "${x}" ] ; then
				c=$(( ${c} + 1 ))
			fi
		done
		if [ ${c} -eq ${#L[@]} ] ; then
			return 0
		fi
		local now=$(date +"%s")
		if [ ${now} -gt ${sf} ] ; then
			return 1
		fi
	done
	return 1
}

service_started() {
	local name="${1}"
	if initctl \
		| grep "running" \
		| grep "${name}" 2>/dev/null 1>/dev/null ; then
		true
	else
		false
        fi
}
