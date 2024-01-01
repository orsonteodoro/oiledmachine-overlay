#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

source /etc/finit.d/scripts/inspircd-lib.sh

start_pre() {
	get_ready_dir "0750" "inspircd:inspircd" "/run/inspircd/"
}

start_pre
