# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="array-tools:1.0.6 glob:4.0.0"
#array-tools:1.0.0 refers to object-ting which has been deleted use 1.0.6 instead
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="a few more Filesystem functions"

LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_install() {
        node-module_src_install
	install_node_module_binary "bin/cli.js" "/usr/local/bin/${PN}-${SLOT}"
}

