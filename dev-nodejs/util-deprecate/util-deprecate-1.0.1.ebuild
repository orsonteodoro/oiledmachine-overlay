# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NODE_MODULE_EXTRA_FILES="browser.js node.js"

inherit node-module

DESCRIPTION="The Node.js util.deprecate() function with browser support"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md History.md )
