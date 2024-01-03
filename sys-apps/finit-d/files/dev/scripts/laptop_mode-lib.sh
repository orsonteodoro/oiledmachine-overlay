#!/bin/sh
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/app-laptop/laptop-mode-tools
# =app-laptop/laptop-mode-tools-1.74::gentoo

. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"laptop_mode"}

checkconfig() {
	if [ ! -f /proc/sys/vm/laptop_mode ] ; then
		eerror "Kernel does not support laptop_mode"
		return 1
	fi
}
