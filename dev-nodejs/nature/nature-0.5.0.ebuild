# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="wodge:0.6.0"

inherit node-module

DESCRIPTION="Classify the things in your world and how they interact."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_install() {
        node-module_src_install
        use examples && dodoc -r example
}

