#!/bin/bash
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/app-laptop/laptop-mode-tools

source /etc/finit.d/scripts/laptop_mode-lib.sh

start() {
	checkconfig || return 1

	ebegin "Starting laptop_mode"
	# bug #342049 fix
	# check if dir exists and creates if it doesn't
	get_ready_dir "755" "root:root" "/var/run/laptop-mode-tools"
	touch /var/run/laptop-mode-tools/enabled
	/usr/sbin/laptop_mode auto >/dev/null
	eend $?
}

start
