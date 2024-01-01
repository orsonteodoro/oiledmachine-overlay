#!/bin/bash
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-vpn/tor

start_pre() {
	checkconfig || return 1
	get_ready_dir "0755" "tor:tor" "/run/tor"
}

start_pre
