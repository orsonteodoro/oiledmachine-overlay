# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit node-module

DESCRIPTION="adds colouring and cursor control features to the console"

LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( README.md )

src_install() {
        node-module_src_install
        use examples && dodoc -r example
}

