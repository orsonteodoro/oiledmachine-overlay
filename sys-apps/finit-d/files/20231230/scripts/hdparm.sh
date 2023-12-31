#!/bin/bash
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

source /etc/conf.d/hdparm

do_hdparm() {
	local e=
	eval e=\$${extra_args}
	[[ -z "${args}${all_args}${e}" ]] && return 0

	if [[ -n "${args:=${all_args} ${e}}" ]] ; then
		local orgdevice=$(readlink -f "${device}")
		if [[ -b "${orgdevice}" ]] ; then
			hdparm ${args} "${device}" > /dev/null
		fi
	fi
}

scan_nondevfs() {
	# non-devfs compatible system
	local device

	local L=(
		$(realpath /dev/hd* /dev/sd* /dev/cdrom* | sed "/*/d")
	)

	device_step() {
		[[ -e "${device}" ]] || continue
		case "${device}" in
			*[0-9]) return ;;
			/dev/hd*)  extra_args="pata_all_args" ;;
			/dev/sd*)  extra_args="sata_all_args" ;;
			*)         extra_args="_no_xtra_args" ;;
		esac

		# check that the block device really exists by
		# opening it for reading
		local errmsg= status= nomed=1
		errmsg=$(export LC_ALL=C ; : 2>&1 <"${device}")
		status=$?
		case ${errmsg} in
		    *": No medium found") nomed=0;;
		esac
		if [[ -b "${device}" ]] && [[ "${status}" = "0" || "${nomed}" = "0" ]] ; then
			local conf_var="${device##*/}_args"
			eval args=\$${conf_var}
			do_hdparm
		fi
	}

	for device in ${L[@]} ; do
		device_step &
	done
}

get_bootparam() {
	local arg="${1}"
	grep -q "${arg}" /proc/cmdline
}

main() {
	if get_bootparam "nohdparm" ; then
		return 0
	fi
	scan_nondevfs
}

main
