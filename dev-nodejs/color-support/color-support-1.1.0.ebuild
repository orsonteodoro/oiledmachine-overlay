# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="browser.js bin.js"

inherit node-module

DESCRIPTION="A module which will endeavor to guess your terminal's level of color support"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_install() {
        node-module_src_install
	install_node_module_binary "bin.js" "/usr/local/bin/${PN}-${SLOT}"
}
