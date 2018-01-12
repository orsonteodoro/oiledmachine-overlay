# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="signals.js"

inherit node-module

DESCRIPTION="When you want to fire an event no matter how a process exits"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
