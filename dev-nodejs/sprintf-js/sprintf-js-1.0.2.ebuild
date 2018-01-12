# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="demo dist src gruntfile.js"

inherit node-module

DESCRIPTION="JavaScript sprintf implementation"

LICENSE="BSD-3"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
