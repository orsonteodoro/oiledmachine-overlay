#/bin/bash
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

get_ready_dir "0775;root:lp;/var/cache/cups"
get_ready_dir "0775;root:lp;/var/cache/cups/rss" &
get_ready_dir "0755;root:lp;/run/cups" &
get_ready_dir "0511;lp:lpadmin;/run/cups/certs" &
