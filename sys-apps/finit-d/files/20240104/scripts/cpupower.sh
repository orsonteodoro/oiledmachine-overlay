#!/bin/sh
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-power/cpupower

. /etc/finit.d/scripts/cpupower-lib.sh

start() {
	change "${START_OPTS}"
}

start
