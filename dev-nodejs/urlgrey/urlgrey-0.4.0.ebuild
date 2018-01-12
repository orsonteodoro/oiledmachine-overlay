# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8.6"
NODE_MODULE_DEPEND="tape:2.3.0"
NODE_MODULE_EXTRA_FILES="browser coverage tapetest.js urlgrey.png util.js"

inherit node-module

DESCRIPTION="urlgrey is a library for url querying and manipulation"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
