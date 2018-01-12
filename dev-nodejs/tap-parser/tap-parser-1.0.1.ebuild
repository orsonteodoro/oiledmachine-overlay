# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="events-to-array:1.0.1
	inherits:2.0.1
	js-yaml:3.2.7"
NODE_MODULE_EXTRA_FILES="bin old.js scripts"

inherit node-module

DESCRIPTION="Parse the test anything protocol"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( readme.markdown )

src_install() {
	node-module_src_install
	use examples && dodoc -r example
}
