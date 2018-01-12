# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit node-module

NODE_MODULE_DEPEND="minimist:0.0.8"
NODE_MODULE_EXTRA_FILES="bin"

DESCRIPTION="Recursively mkdir, like mkdir -p"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( readme.markdown )

src_install() {
	node-module_src_install
	use examples && dodoc -r examples
}
