# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="prr:0.0.0"
NODE_MODULE_EXTRA_FILES="build.js cli.js custom.js"

inherit node-module

DESCRIPTION="libuv errno details exposed"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
