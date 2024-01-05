#!/bin/sh
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/media-gfx/sane-backends
# =media-gfx/sane-backends-1.2.1::gentoo

. /etc/conf.d/saned
. /etc/finit.d/scripts/lib.sh

start() {
	set -- -a ${SANED_USER:-"root"}
	exec "/usr/sbin/saned" "$@"
}

start
