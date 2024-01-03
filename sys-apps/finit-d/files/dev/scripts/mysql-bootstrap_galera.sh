#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-db/mysql-init-scripts

. /etc/finit.d/scripts/mysql-lib.sh

if bootstrap_galera ; then
	if initctl | grep "stopped" | grep "${SVCNAME}" ; then
		start "galera"
	fi
fi
