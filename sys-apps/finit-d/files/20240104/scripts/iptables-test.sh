#!/bin/sh
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-firewall/iptables/files

. /etc/finit.d/scripts/iptables-lib.sh

test() {
	checkkernel || exit 1
	checkrules || exit 1
}

test
