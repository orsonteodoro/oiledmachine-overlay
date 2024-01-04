#!/bin/sh
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-fs/cryptsetup

. /etc/finit.d/scripts/dmcrypt-lib.sh

stop() {
	local line print_header

	# Break down all mappings
	print_header=true
	grep -E "^(target|swap)=" "${conf_file}" | \
	while read line ; do
		${print_header} && einfo "Removing dm-crypt mappings"
		print_header=false

		target= swap=
		eval ${line}

		[ -n "${swap}" ] && target="${swap}"
		if [ -z "${target}" ] ; then
			ewarn "invalid line in ${conf_file}: ${line}"
			continue
		fi

		ebegin "  ${target}"
		cryptsetup ${header_opt} remove "${target}"
		eend $?
	done

	# Break down loop devices
	print_header=true
	grep '^source=./dev/loop' "${conf_file}" | \
	while read line ; do
		${print_header} && einfo "Detaching dm-crypt loop devices"
		print_header=false

		source=
		eval ${line}

		ebegin "  ${source}"
		losetup -d "${source}"
		eend $?
	done

	return 0
}

stop
