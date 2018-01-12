# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="browser.js"
NODE_MODULE_DEPEND="brace-expansion:1.0.0"

inherit node-module

DESCRIPTION="A glob matcher in javascript"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
