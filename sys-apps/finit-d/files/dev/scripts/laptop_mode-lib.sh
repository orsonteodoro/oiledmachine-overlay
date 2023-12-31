#!/bin/bash
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/app-laptop/laptop-mode-tools

source /etc/finit.d/scripts/lib.sh

checkconfig() {
	if [[ ! -f /proc/sys/vm/laptop_mode ]] ; then
		eerror "Kernel does not support laptop_mode"
		return 1
	fi
}
