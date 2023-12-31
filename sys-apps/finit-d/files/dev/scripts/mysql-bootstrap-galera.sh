#!/bin/bash
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Scripts from dev-db/mysql-init-scripts at https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-db/mysql-init-scripts

source /etc/finit.d/scripts/mysql-lib.sh

bootstrap_galera() {
	MY_ARGS="--wsrep-new-cluster ${MY_ARGS}"
	mark_service_starting
	if start ; then
		mark_service_started
		return 0
	else
		mark_service_stopped
		return 1
	fi
}

bootstrap_galera
