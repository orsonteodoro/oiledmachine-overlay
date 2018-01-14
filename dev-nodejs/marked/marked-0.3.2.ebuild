# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="${PN}.min.js"

inherit node-module

DESCRIPTION="A markdown parser built for speed"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-util/uglifyjs"

DOCS=( README.md doc/broken.md doc/todo.md )

src_install() {
        node-module_src_install
	install_node_module_binary "bin/${PN}" "/usr/local/bin/${PN}-${SLOT}"

	doman man/marked.1
}

