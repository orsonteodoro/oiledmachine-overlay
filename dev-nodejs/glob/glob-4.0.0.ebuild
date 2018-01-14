# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="inherits:2.0.1 minimatch:0.3.0"

inherit node-module

DESCRIPTION="A little globber"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_install() {
        node-module_src_install
        use examples && dodoc -r examples
}
