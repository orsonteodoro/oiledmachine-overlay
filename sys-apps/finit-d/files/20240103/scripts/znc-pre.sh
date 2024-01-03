#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

start_pre() {
	checkpath "d" "znc:znc" "0770" "/run/znc"
}

start_pre
