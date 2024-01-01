#!/bin/sh
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-firewall/iptables/files

source /etc/finit.d/scripts/iptables-lib.sh

start_pre() {
	checkconfig || return 1
}

start_pre
