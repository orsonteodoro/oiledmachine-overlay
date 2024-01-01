#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-fs/cryptsetup

source /etc/finit.d/scripts/dmcrypt-lib.sh

start() {
	local print_header=true cryptfs_status=0
	local gpg_options key loop_file target targetline options pre_mount post_mount source swap remdev

	local x
	for x in $(cat /proc/cmdline) ; do
		case "${x}" in
		key_timeout=*)
			dmcrypt_key_timeout=$(get_bootparam_val "${x}")
			;;
		esac
	done

	while read targetline <&3 ; do
		case ${targetline} in
		# skip comments and blank lines
		""|"#"*) continue ;;
		# skip service-specific openrc configs #377927
		rc_*) continue ;;
		esac

		${print_header} && ebegin "Setting up dm-crypt mappings"
		print_header=false

		# check for the start of a new target/swap
		case ${targetline} in
		target=*|swap=*)
			# If we have a target queued up, then execute it
			dm_crypt_execute

			# Prepare for the next target/swap by resetting variables
			unset gpg_options key loop_file target options pre_mount post_mount source swap remdev wait header header_opt
			;;

		gpg_options=*|remdev=*|key=*|loop_file=*|options=*|pre_mount=*|post_mount=*|wait=*|source=*|header=*)
			if [[ -z "${target}${swap}" ]] ; then
				ewarn "Ignoring setting outside target/swap section: ${targetline}"
				continue
			fi
			;;

		dmcrypt_*=*)
			# ignore global options
			continue
			;;

		*)
			ewarn "Skipping invalid line in ${conf_file}: ${targetline}"
			;;
		esac

		# Queue this setting for the next call to dm_crypt_execute
		eval "${targetline}"
	done 3< ${conf_file}

	# If we have a target queued up, then execute it
	dm_crypt_execute

	ewend ${cryptfs_status} "Failed to setup dm-crypt devices"
}

start
