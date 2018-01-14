# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="handlebars:3.0.0"

inherit node-module

DESCRIPTION="Extends handlebars with a streaming interface for .compile()"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( jsdoc2md/README.hbs README.md)

src_install() {
        node-module_src_install
	install_node_module_binary "bin/cli.js" "/usr/local/bin/${PN}-${SLOT}"
}

