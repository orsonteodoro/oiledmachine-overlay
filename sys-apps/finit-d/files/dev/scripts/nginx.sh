#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/nginx/files
# =www-servers/nginx-1.25.3:mainline::gentoo

source /etc/finit.d/scripts/nginx-lib.sh

RC_CMD="start"
start_pre() {
	if [ "${RC_CMD}" != "restart" ]; then
		configtest || return 1
	fi
}

start() {
	exec "${command}" ${command_args}
}

if start_pre ; then
	start
fi
