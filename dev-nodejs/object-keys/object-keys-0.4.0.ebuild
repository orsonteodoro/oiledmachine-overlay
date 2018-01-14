# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="isArguments.js foreach.js shim.js"

inherit node-module

DESCRIPTION="An Object.keys replacement, in case Object.keys is not available"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
