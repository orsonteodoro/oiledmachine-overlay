# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="balanced-match:0.2.0
	concat-map:0.0.0"

inherit node-module

DESCRIPTION="Brace expansion as known from sh/bash"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( README.md )

src_install() {
	node-module_src_install
	use examples && dodoc example.js
}
