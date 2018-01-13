# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="esprima:2.2.0 argparse:1.0.2"
NODE_MODULE_EXTRA_FILES="bin dist"

inherit node-module

DESCRIPTION="YAML 1.2 parser and serializer"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( README.md CHANGELOG.md )

src_install() {
	node-module_src_install
	install_node_module_binary "bin/${PN}.js" "/usr/local/bin/${PN}-${SLOT}"
	use examples && dodoc -r examples
}
