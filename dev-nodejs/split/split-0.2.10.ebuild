# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="through:2.0.0"

inherit node-module

DESCRIPTION="split a Text Stream into a Line Stream"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( readme.markdown )

src_install() {
	node-module_src_install
	use examples && dodoc -r example
}
