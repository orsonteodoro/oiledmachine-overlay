#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later

source /etc/conf.d/svnserve
source /etc/finit.d/scripts/lib.sh

pidfile="/var/run/svnserve.pid"
command="/usr/bin/svnserve"
command_args="--foreground --daemon ${SVNSERVE_OPTS:---root=/var/svn}"

start() {
	# Ensure that we run from a readable working dir, and that we do not
	# lock filesystems when being run from such a location.
	cd /

	declare -a "args=(${command_args})"
	exec "${command}" "${args[@]}"
}

start
