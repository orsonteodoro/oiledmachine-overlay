#!/bin/sh
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/media-gfx/sane-backends

. /etc/conf.d/saned
. /etc/finit.d/scripts/lib.sh
pidfile="/var/run/saned/saned.pid"

start_pre() {
	checkpath "d" "${SANED_USER:-root}" "0644" "${pidfile%/*}"
}

start_pre
