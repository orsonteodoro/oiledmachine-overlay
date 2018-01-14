# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit node-module

DESCRIPTION="Throttle a function"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( Readme.md History.md )

src_compile() {
	true
}

src_install() {
        node-module_src_install
        use examples && dodoc -r example.js
}

