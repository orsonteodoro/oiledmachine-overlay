# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="dist src"

inherit node-module

DESCRIPTION="JavaScript sprintf implementation"

LICENSE="BSD-3"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( README.md )

src_install() {
        node-module_src_install
        use examples && dodoc -r demo
}

