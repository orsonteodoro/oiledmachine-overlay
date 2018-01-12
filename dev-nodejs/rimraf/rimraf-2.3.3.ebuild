# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="glob:4.4.2"
NODE_MODULE_EXTRA_FILES="bin.js"

inherit node-module

DESCRIPTION="A deep deletion module for node (like rm -rf)"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
