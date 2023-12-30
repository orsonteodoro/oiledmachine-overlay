#/bin/bash
L=(
	"d;0775;root:lp;/var/cache/cups"
	"d;0775;root:lp;/var/cache/cups/rss"
	"d;0755;root:lp;/run/cups"
	"d;0511;lp:lpadmin;/run/cups/certs"
)

local row
for row in ${L[@]} ; do
	local type=$(cat "${row}" | cut -f 1 -d ";")
	local mod=$(cat "${row}" | cut -f 2 -d ";")
	local owner=$(cat "${row}" | cut -f 3 -d ";")
	local path=$(cat "${row}" | cut -f 4 -d ";")
	if [[ "${type}" == "d" && ! -e "${path}" ]] ; then
		mkdir -p "${path}"
		chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	elif [[ "${type}" == "d" && -d "${path}" ]] ; then
		chown "${owner}" "${path}"
		chmod "${mod}" "${path}"
	fi
done
