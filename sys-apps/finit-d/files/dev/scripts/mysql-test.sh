#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/dev-db/mysql-init-scripts
# Verify the server's configuration

source /etc/finit.d/scripts/mysql-lib.sh

checkconfig
