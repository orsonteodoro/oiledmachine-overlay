# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_NAME="${PN//-/.}"
NODE_MODULE_DEPEND="request:2.42.0 urlgrey:0.4.0"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="lcov posting to codecov.io"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_compile() {
	true
}
