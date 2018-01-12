# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="esprima:2.0.0 argparse:1.0.0"
NODE_MODULE_EXTRA_FILES="bin dist"

inherit node-module

DESCRIPTION="YAML 1.2 parser and serializer"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( README.md )

src_install() {
	node-module_src_install

	use examples && dodoc -r examples
}
