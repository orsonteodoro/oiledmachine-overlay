#!/bin/sh
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later

. /etc/conf.d/svnserve
. /etc/finit.d/scripts/lib.sh

pidfile="/var/run/svnserve.pid"
command="/usr/bin/svnserve"

start() {
	# Ensure that we run from a readable working dir, and that we do not
	# lock filesystems when being run from such a location.
	cd /

	set -- --foreground --daemon ${SVNSERVE_OPTS:-"--root=/var/svn"}
	exec "${command}" $@
}

start
